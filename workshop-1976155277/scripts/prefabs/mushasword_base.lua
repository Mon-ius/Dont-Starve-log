-----------------------------

local assets=
{
	Asset("ANIM", "anim/mushasword_base.zip"),
	Asset("ANIM", "anim/swap_mushasword_base.zip"),
	Asset("ANIM", "anim/swap_mushasword_frost1.zip"),	
    	Asset("ATLAS", "images/inventoryimages/mushasword_base.xml"),
	Asset("IMAGE", "images/inventoryimages/mushasword_base.tex"),
}

local function finished(inst)
local owner = inst.components.inventoryitem.owner
local inv = inst.components.inventoryitem
local item = SpawnPrefab("mushasword")
    if inv ~= nil and owner ~= nil then
        SpawnPrefab("statue_transition_2").Transform:SetPosition(owner:GetPosition():Get())
		if owner.components.container then
		owner.components.container:GiveItem(item)
		else
		item.Transform:SetPosition(inst:GetPosition():Get())
		end
	else
        SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
		item.Transform:SetPosition(inst:GetPosition():Get())
    end
    inst:Remove()
end

local function levelexp(inst,data)

	local max_exp = 310
	local exp = math.min(inst.level, max_exp)


if inst.level >=0 and inst.level <10 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/10")
elseif inst.level >=10 and inst.level <30 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/30")
elseif inst.level >=30 and inst.level <50 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/50")
elseif inst.level >=50 and inst.level <70 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/70")
elseif inst.level >=70 and inst.level <90 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/90")
elseif inst.level >=90 and inst.level <120 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/120")
elseif inst.level >=120 and inst.level <150 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/150")
elseif inst.level >=150 and inst.level <180 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/180")
elseif inst.level >=180 and inst.level <210 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/210")
elseif inst.level >=210 and inst.level <300 then
inst.components.talker:Say("-["..STRINGS.MUSHA_WEAPON_SWORD_BASE_UP.."] \n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]\n".. (inst.level).."/300(Upgrade)")
elseif inst.level >=300 then
if not inst.finished then
inst.components.talker:Say(STRINGS.MUSHA_WEAPON_SWORD_BASE_UP.."\n[MAX]")
inst.finished = true
finished(inst)
end
end
end

local function onpreload(inst, data)
	if data then
		if data.level then
		inst.level = data.level
			levelexp(inst)
end
	end
		end
local function onsave(inst, data)
	data.level = inst.level
end

local function Upgradedamage(inst, data)
if inst.components.fueled:IsEmpty() then
inst.broken = true
elseif not inst.components.fueled:IsEmpty() then
inst.broken = false
end

if inst.broken then
   inst.components.weapon:SetDamage(1)
	inst.components.talker:Say(STRINGS.MUSHA_WEAPON_BROKEN.."\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(1)")
  
elseif not inst.broken then

 if inst.level >=0 and inst.level <10 then
    inst.components.weapon:SetDamage(20)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV1)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(20)")
 elseif inst.level >=10 and inst.level <30 then
    inst.components.weapon:SetDamage(22)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV2)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(22)")
 elseif inst.level >=30 and inst.level <50 then
    inst.components.weapon:SetDamage(24)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV3)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(24)")
 elseif inst.level >=50 and inst.level <70 then
    inst.components.weapon:SetDamage(26)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV4)]\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(26)")
  elseif inst.level >=70 and inst.level <90 then
    inst.components.weapon:SetDamage(28)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV5)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(28)")
elseif inst.level >=90 and inst.level <120 then
    inst.components.weapon:SetDamage(30)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV6)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(30)")
elseif inst.level >=120 and inst.level <150 then
    inst.components.weapon:SetDamage(32)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV7)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(32)")
elseif inst.level >=150 and inst.level <180 then
    inst.components.weapon:SetDamage(34)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV8)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(34))")
elseif inst.level >=180 and inst.level <210 then
    inst.components.weapon:SetDamage(36)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.."(LV9)\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(36)")
elseif inst.level >=210 then
    inst.components.weapon:SetDamage(38)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE_UP.."\n"..STRINGS.MUSHA_WEAPON_DAMAGE.."(38)\n"..STRINGS.MUSHA_WEAPON_FIRE.."(12/12)")
end
end
end

local function OnDurability(inst, data)
inst.broken = true
 	Upgradedamage(inst)
end
-------- --------
-------- --------
local function forgelab(inst, data)
 if inst.active_forge then
local x,y,z = inst.Transform:GetWorldPosition()
local ents = TheSim:FindEntities(x,y,z, 6, {"forge_musha"})
for k,v in pairs(ents) do
if inst.active_forge then
v.active_forge =  true
inst.active_forge = false
end end 
 end end
-------- --------
local function TakeItem(inst, item, data)
local expchance0 = 1
local expchance1 = 0.3
local expchance2 = 0.2
local expchance3 = 0.12
	inst.components.fueled:DoDelta(5000000)
	SpawnPrefab("splash").Transform:SetPosition(inst:GetPosition():Get())
inst.broken = false      
Upgradedamage(inst)
if not inst.forgelab_on then
   if math.random() < expchance1 and inst.level <= 310 then
	inst.level = inst.level + 2
	levelexp(inst)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.." \n"..STRINGS.MUSHA_ITEM_LUCKY.." +(2)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
    elseif  math.random() < expchance2 and inst.level <= 310 then
	inst.level = inst.level + 5
	levelexp(inst)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.." \n"..STRINGS.MUSHA_ITEM_LUCKY.." +(5)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
	elseif  math.random() < expchance3 and inst.level <= 310 then
	inst.level = inst.level + 8
	levelexp(inst)
	inst.components.talker:Say("-"..STRINGS.MUSHA_WEAPON_SWORD_BASE.." \n"..STRINGS.MUSHA_ITEM_LUCKY.." +(8)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
	elseif  math.random() < expchance0 and inst.level <= 310 then
	inst.level = inst.level + 1
	levelexp(inst)
    end
elseif inst.forgelab_on then
inst.active_forge = true
forgelab(inst)
	  if math.random() < expchance1 and inst.level <= 4005 then
	inst.level = inst.level + 10
	levelexp(inst)
	inst.components.talker:Say(STRINGS.MUSHA_TALK_FORGE_LUCKY.."\n+(10)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
    elseif  math.random() < expchance2 and inst.level <= 4005 then
	inst.level = inst.level + 25
	levelexp(inst)
	inst.components.talker:Say(STRINGS.MUSHA_TALK_FORGE_LUCKY.."\n+(25)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
	elseif  math.random() < expchance3 and inst.level <= 4005 then
	inst.level = inst.level + 40
	levelexp(inst)
	inst.components.talker:Say(STRINGS.MUSHA_TALK_FORGE_LUCKY.."\n+(40)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
	elseif  math.random() < expchance0 and inst.level <= 4005 then
	inst.level = inst.level + 5
	levelexp(inst)
	inst.components.talker:Say(STRINGS.MUSHA_TALK_FORGE_LUCKY.."\n+(5)\n["..STRINGS.MUSHA_ITEM_GROWPOINTS.."]".. (inst.level))
    end
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end
	if inst.broken then
	inst.broken = false 
	end
end
-------- --------
-------- --------
local function OnLoad(inst, data)
    Upgradedamage(inst)
end

local function onattack_base(inst, attacker, target)
local damagedur1 = 0.2
local damagedur2 = 0.5
local damagedur3 = 0.7
local damagedur4 = 1
local expchance = 0.2
local expchance2 = 0.1
local flamechance = 0.12
if math.random() < expchance2 and not inst.broken and inst.level <= 300 then
	inst.level = inst.level + 1
	inst.components.talker:Say(STRINGS.MUSHA_WEAPON..":GP+1")
	if inst.level >=300 then
	levelexp(inst)
	end
	end
    if target and not inst.broken and math.random() < damagedur1 then
inst.components.fueled:DoDelta(-150000)
    elseif target and not inst.broken and math.random() < damagedur2 then
inst.components.fueled:DoDelta(-75000)
    elseif target and not inst.broken and math.random() < damagedur3 then
inst.components.fueled:DoDelta(-35000)
    elseif target and not inst.broken and math.random() < damagedur4 then
inst.components.fueled:DoDelta(-20000)
    elseif target and inst.broken then
SpawnPrefab("splash").Transform:SetPosition(inst:GetPosition():Get())
	inst.components.talker:Say(STRINGS.MUSHA_WEAPON_BROKEN.." \n"..STRINGS.MUSHA_WEAPON_DAMAGE.." (1)")
    end
 
	-----
	if  math.random() < flamechance and target.components.burnable and not target:HasTag("structure") and not inst.boost and inst.level >=210 then
        target.components.burnable:Ignite()
        target.components.health:DoDelta(-12)
		
	end
	
	local player = GetPlayer()
		if target and not target:HasTag("wall") and not target:HasTag("structure") and player:HasTag("framea") and not (player:HasTag("lightningblue1") and player:HasTag("lightningblue2")) then
        if target.components.burnable then
		target.components.burnable:Ignite() end
        --attacker.components.sanity:DoDelta(-2)
		target.components.health:DoDelta(-10)
		player:RemoveTag("framea")
		end
	
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end
    if target.components.burnable and target.components.burnable:IsBurning() then
        target.components.burnable:Extinguish()
    end
    if target.components.combat and not target:HasTag("companion") then
        target.components.combat:SuggestTarget(attacker)
    end
end


local function onequip(inst, owner)
	owner:AddTag("phoenixblade")
	owner.fire = true
    Upgradedamage(inst)

    owner.AnimState:OverrideSymbol("swap_object", "swap_mushasword_base", "swap_nightmaresword")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 

if inst.level >=210 then
    owner.AnimState:OverrideSymbol("swap_object", "swap_mushasword", "swap_nightmaresword")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end
end

local function onunequip(inst, owner) 
	owner:RemoveTag("phoenixblade") 
	owner:RemoveTag("framea") 
	owner.fire = false
    Upgradedamage(inst)
    if inst.task then inst.task:Cancel() inst.task = nil end
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 

end

local function OnDropped(inst,data)
    end
local function OnPutInInventory(inst)
    end
	
local function consume(inst, owner)
if not inst.broken then
inst.components.fueled:DoDelta(-25000)
end
end


local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
 	
    inst.entity:AddLight()
	inst.Light:SetRadius(.4)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(80/255,120/255,250/255)
	inst.Light:Enable(true)
	
  MakeInventoryPhysics(inst)  
  
    inst.AnimState:SetBank("nightmaresword")
    inst.AnimState:SetBuild("mushasword_base")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(1, 1, 1, 0.7)

 
	-- inst:AddTag("sharp")
	  inst:AddTag("musha_items")
	 inst:AddComponent("talker")
	
    inst.components.talker.fontsize = 20
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(0.75, 0.75, 0.75, 1)
    inst.components.talker.offset = Vector3(200,-250,0)
    inst.components.talker.symbol = "swap_object"
	

    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(Upgradedamage)
    inst.components.weapon:SetOnAttack(onattack_base)

    inst:AddComponent("inspectable")
	
	   inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.atlasname = "images/inventoryimages/mushasword_base.xml"
     inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon( "blade_b.tex" )
  local player = GetPlayer()
--if IsDLCInstalled(CAPY_DLC) then
if SaveGameIndex:IsModeShipwrecked() or player:HasTag("dlc2") then
         inst.DLC2 = true
		end			
		
	local player = GetPlayer()
  	if SaveGameIndex:IsModeShipwrecked() or SaveGameIndex:IsModePorkland() then
		inst.DLC2 = true
		inst:AddComponent("tool")
		inst.components.tool:SetAction(ACTIONS.HACK)
	end
	
    if SaveGameIndex:IsModeShipwrecked() or SaveGameIndex:IsModePorkland() then
	MakeInventoryFloatable(inst, "idle_water", "idle")	end 

    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	--inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    	inst.components.inventoryitem.atlasname = "images/inventoryimages/mushasword_base.xml"
  
    inst.OnLoad = OnLoad

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

        inst:AddComponent("fueled")
       inst.components.fueled.fueltype = "CHEMICAL"
       inst.components.fueled:InitializeFuelLevel(30000000)
		
       inst.components.fueled:SetDepletedFn(OnDurability)
        inst.components.fueled.ontakefuelfn = TakeItem
        inst.components.fueled.accepting = true
inst.components.fueled:StopConsuming()        
inst.boost = false 

	inst.level = 0
inst:ListenForEvent("levelup", levelexp)
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload

    return inst
end

return Prefab( "images/inventoryimages/mushasword_base", fn, assets) 