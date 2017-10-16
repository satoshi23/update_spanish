--鎖龍蛇－スカルデット
--Skulldeat, the Chained Dracoserpent
--Script by nekrozar
function c74997493.initial_effect(c)
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c74997493.lkcon)
	e1:SetOperation(c74997493.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c74997493.regcon)
	e2:SetOperation(c74997493.regop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74997493,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c74997493.drcon)
	e3:SetTarget(c74997493.drtg)
	e3:SetOperation(c74997493.drop)
	c:RegisterEffect(e3)
end
function c74997493.matfilter(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
end
function c74997493.lkcheck(c,sg)
	return sg:FilterCount(c74997493.lkcheck2,c,c)+1==sg:GetCount()
end
function c74997493.lkcheck2(c,mc)
	return not c:IsCode(mc:IsCode())
end
function c74997493.lkgoal(c,tp,lc,ct,sg)
	return sg:GetCount()>1 and sg:CheckWithSumEqual(aux.GetLinkCount,lc:GetLink(),ct,ct)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and sg:IsExists(c74997493.lkcheck,1,nil,sg)
end
function c74997493.lkselect(c,tp,lc,ct,mg,sg)
	sg:AddCard(c)
	ct=ct+1
	local res=c74997493.lkgoal(c,tp,lc,ct,sg) or mg:IsExists(c74997493.lkselect,1,sg,tp,lc,ct,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c74997493.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c74997493.matfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c74997493.lkselect,1,nil,tp,c,0,mg,sg)
end
function c74997493.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c74997493.matfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i=0,98 do
		local cg=mg:Filter(c74997493.lkselect,sg,tp,c,i,mg,sg)
		if cg:GetCount()==0 then break end
		local minct=1
		if c74997493.lkgoal(c,tp,c,i,sg) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function c74997493.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c74997493.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterialCount()>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(74997493,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c74997493.atkcon)
		e1:SetOperation(c74997493.atkop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(74997493,3))
	end
	if c:GetMaterialCount()>=3 then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(74997493,1))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetTarget(c74997493.sptg)
		e3:SetOperation(c74997493.spop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(74997493,4))
	end
end
function c74997493.cfilter(c,e,g)
	return c:IsFaceup() and g:IsContains(c) and (not e or c:IsRelateToEffect(e))
end
function c74997493.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c74997493.cfilter,1,nil,nil,lg)
end
function c74997493.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if not lg then return end
	local g=eg:Filter(c74997493.cfilter,nil,e,g)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c74997493.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74997493.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74997493.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c74997493.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c74997493.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c74997493.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterialCount()==4
end
function c74997493.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
end
function c74997493.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==4 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,3,3,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.SortDecktop(p,p,3)
		for i=1,3 do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end
