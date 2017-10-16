--リボルブート・セクター
--Revolve Boot Sector
--Scripted by Eerie Code
function c101003053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x102))
	e2:SetValue(300)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e3)
	--special summon (hand)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101003053,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,101003053)
	e4:SetTarget(c101003053.sptg1)
	e4:SetOperation(c101003053.spop1)
	c:RegisterEffect(e4)
	--special summon (GY)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101003053,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,101003053)
	e5:SetCondition(c101003053.spcon)
	e5:SetTarget(c101003053.sptg2)
	e5:SetOperation(c101003053.spop2)
	c:RegisterEffect(e5)
end
function c101003053.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101003053.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101003053.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101003053.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101003053.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Group.CreateGroup()
	while sg:GetCount()<math.min(ft,2) do
		local cancel=sg:GetCount()>0
		local cg=g
		if sg:GetCount()>0 then
			cg=g:Filter(aux.NOT(Card.IsCode),nil,sg:GetFirst():GetCode())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Group.SelectUnselect(cg,sg,tp,cancel,cancel,1,2)
		if not tc then break end
		if not sg:IsContains(tc) then
		    	sg:AddCard(tc)
		else
		    	sg:RemoveCard(tc)
		end
	end
	if sg:GetCount()==0 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101003053.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c101003053.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101003053.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101003053.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101003053.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<1 or ct<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ft=ft-1
		ct=ct-1
		while ft>0 and ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101003053,2)) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g:Select(tp,1,1,nil)
			sg:AddCard(sg2:GetFirst())
			g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
			ft=ft-1
			ct=ct-1
		end
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
