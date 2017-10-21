--リンケージ・ホール
--Linkage Hole
--Scripted by Eerie Code
function c73275815.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,73275815)
	e1:SetCondition(c73275815.condition)
	e1:SetTarget(c73275815.target)
	e1:SetOperation(c73275815.activate)
	c:RegisterEffect(e1)
end
function c73275815.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsLinkAbove,tp,LOCATION_MZONE,0,1,nil,4)
end
function c73275815.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsLinkAbove,tp,LOCATION_MZONE,0,nil,3)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return ct>0 and dg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c73275815.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsLinkAbove,tp,LOCATION_MZONE,0,nil,3)
	if ct<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

