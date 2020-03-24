local assets=
{
	Asset("ANIM", "anim/musha_egg8.zip"),
	Asset("ATLAS", "images/inventoryimages/musha_egg8.xml"),
	Asset("IMAGE", "images/inventoryimages/musha_egg8.tex"),
	Asset("IMAGE", "images/inventoryimages/musha_egg_cracked8.tex"),
	Asset("ATLAS", "images/inventoryimages/musha_egg_cracked8.xml"),
	Asset("ATLAS", "images/inventoryimages/musha_egg_cooked.xml"),

}

local prefabs = 
{
	"musha_rp1",
	"musha_rp2",
	"musha_rp3",
	"musha_rp4",
	"musha_rp5",
	"musha_rp6",
	"musha_rp7",
	"musha_rpice",

	"musha_egg_cracked8",
	--"musha_egg_cooked",
	--"spoiled_food",
}

local loot_hot = 
{
   -- "musha_egg8",
}

local loot_cold = 
{
   -- "musha_egg8",
}
----------------

local function green_apple(inst)
inst:DoTaskInTime( 1, function() 
local apple = SpawnPrefab("green_apple_plant")
apple.Transform:SetPosition(inst:GetPosition():Get()) 
SpawnPrefab("pine_needles").Transform:SetPosition(apple:GetPosition():Get()) 
apple.AnimState:PlayAnimation("grow") end)
end
local function Hatch1(inst)
    
   
    local rp1= SpawnPrefab("musha_rp1")
    rp1.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp1.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch2(inst)
    
   
    local rp2= SpawnPrefab("musha_rp2")
    rp2.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp2.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch3(inst)
    
   
    local rp3= SpawnPrefab("musha_rp3")
    rp3.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp3.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch4(inst)
    
   
    local rp4= SpawnPrefab("musha_rp4")
    rp4.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp4.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch5(inst)
    
   
    local rp5= SpawnPrefab("musha_rp5")
    rp5.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp5.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch6(inst)
    
   
    local rp6= SpawnPrefab("musha_rp6")
    rp6.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp6.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch7(inst)
    
   
    local rp7= SpawnPrefab("musha_rp7")
    rp7.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp7.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end
local function Hatch8(inst)
    
   
    local rp8= SpawnPrefab("musha_rpice")
    rp8.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rp8.sg:GoToState("hatch")
	if not inst.cooking_born then	green_apple(inst)	end
    inst:Remove()
end

local function CheckHatch(inst)
    --print("tallbirdegg - CheckHatch")
local random = 0.1
local last = 1
if inst.components.hatchable.state == "hatch" then
	
    if math.random() < random then
        Hatch1(inst)
    elseif math.random() < random then
        Hatch8(inst)
    elseif math.random() < random then
        Hatch2(inst)
    elseif math.random() < random then
        Hatch3(inst)
    elseif math.random() < random then
        Hatch4(inst)
    elseif math.random() < random then
        Hatch5(inst)
    elseif math.random() < random then
        Hatch6(inst)
    elseif math.random() < random then
        Hatch6(inst)
    elseif math.random() < random then
        Hatch7(inst)
    elseif math.random() < random then
        Hatch8(inst)

    elseif math.random() < random then
        Hatch5(inst)
    elseif math.random() < random then
        Hatch4(inst)
    elseif math.random() < random then
        Hatch3(inst)
    elseif math.random() < random then
        Hatch2(inst)
    elseif math.random() < random then
        Hatch1(inst)
    elseif math.random() < random then
        Hatch8(inst)
    elseif math.random() < random then
        Hatch2(inst)
    elseif math.random() < random then
        Hatch3(inst)
    elseif math.random() < random then
        Hatch4(inst)
    elseif math.random() < random then
        Hatch5(inst)
    elseif math.random() < random then
        Hatch7(inst)
    elseif math.random() < random then
        Hatch8(inst)
    else
        Hatch6(inst)
	
    end
end
end

local function PlayUncomfySound(inst)
    inst.SoundEmitter:KillSound("uncomfy")
    if inst.components.hatchable.toohot then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_steam_LP", "uncomfy")
    elseif inst.components.hatchable.toocold then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_cold_shiver_LP", "uncomfy")
    end
end

local function OnNear(inst)


    if inst.components.playerprox ~= nil and
        inst.components.playerprox:IsPlayerClose() and
        inst.components.hatchable.state == "hatch" then
        CheckHatch(inst)
    end
     --CheckHatch(inst)
end
local function OnFar(inst)
    inst.playernear = false
end

local function OnDropped(inst)
    inst.components.hatchable:StartUpdating()
    CheckHatch(inst)
	inst.holding = false
    PlayUncomfySound(inst)
	inst.Light:Enable(true)
end

local function OnPutInInventory(inst)
    inst.components.hatchable:StopUpdating()
    inst.SoundEmitter:KillSound("uncomfy")
	inst.holding = true
	inst.Light:Enable(false)
end

local function OnPutInInventory_hatched(inst)
    inst.components.hatchable:StartUpdating()
    inst.SoundEmitter:KillSound("uncomfy")
	inst.holding = true
	inst.Light:Enable(false)
end



local function GetStatus(inst)
    if inst.components.hatchable ~= nil and inst.components.hatchable.state == "uncomfy" then
        return (inst.components.hatchable.toohot and "HOT")
            or (inst.components.hatchable.toocold and "COLD")
            or nil
    end
end

local function DropLoot(inst)
     
    inst:AddComponent("lootdropper")
    if inst.components.hatchable.toohot then

        inst.components.lootdropper:SetLoot(loot_hot)
    else
        inst.components.lootdropper:SetLoot(loot_cold)
    end
    inst.components.lootdropper:DropLoot()
end


local function OnHatchState(inst, state)
    --print("tallbirdegg - OnHatchState", state)

    inst.SoundEmitter:KillSound("uncomfy")

    if state == "crack" then
        local cracked = SpawnPrefab("musha_egg_cracked8")
        cracked.Transform:SetPosition(inst.Transform:GetWorldPosition())
        cracked.AnimState:PlayAnimation("crack")
        cracked.AnimState:PushAnimation("idle_happy", true)
        cracked.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
        inst:Remove()
    elseif state == "uncomfy" then
        if inst.components.hatchable.toohot then
            inst.AnimState:PlayAnimation("idle_hot", true)
        elseif inst.components.hatchable.toocold then
            inst.AnimState:PlayAnimation("idle_cold", true)
        end
        PlayUncomfySound(inst)
    elseif state == "comfy" then
        inst.AnimState:PlayAnimation("idle_happy", true)
    elseif state == "hatch" then
        CheckHatch(inst)
    elseif state == "dead" then
        --print("   ACK! *splat*")
        if inst.components.hatchable.toohot then
            inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_jump")
            inst:DoTaskInTime(20*FRAMES, PlaySound, "dontstarve/creatures/egg/egg_hot_explo")
            inst:DoTaskInTime(20*FRAMES, DropLoot)
            inst.AnimState:PlayAnimation("toohot")
        elseif inst.components.hatchable.toocold then
            inst:DoTaskInTime(15*FRAMES, PlaySound, "dontstarve/creatures/egg/egg_cold_freeze")
            inst:DoTaskInTime(30*FRAMES, DropLoot)
            inst.AnimState:PlayAnimation("toocold")
        end

        inst.components.inventoryitem.canbepickedup = false
        inst.persists = false
        inst:ListenForEvent("animover", inst.Remove)
    end
end

-----


local function commonfn(anim, withsound, cookable)
local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    if withsound then
        inst.entity:AddSoundEmitter()
    end
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("musha_egg8")
    inst.AnimState:SetBank("egg")
    inst.AnimState:PlayAnimation("egg")
	
	inst.entity:AddLight()
	inst.Light:SetRadius(1)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(150/255, 150/255, 150/255)
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	inst.Light:Enable(true)
	
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon( "musha_egg8.tex" )
	
	
	if cookable then
        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")
    end
	
    

    

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

	if cookable then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/musha_egg8.xml"
        inst:AddComponent("cookable")
        inst.components.cookable.product = "musha_egg_cooked8"
    end
	
	
	
    return inst
end

local function defaultfn(anim)
	local inst = commonfn(anim, true, true)
		
 	
	
    inst:AddComponent("hatchable")
    inst.components.hatchable:SetOnState(OnHatchState)
    inst.components.hatchable:SetCrackTime(1)
    inst.components.hatchable:SetHatchTime(TUNING.SMALLBIRD_HATCH_TIME)
    inst.components.hatchable:SetHatchFailTime(TUNING.SMALLBIRD_HATCH_TIME * 900000000000)
    
	inst.components.hatchable:StartUpdating()
	
	

    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    inst.components.inspectable.getstatus = GetStatus

    
 
	
	
	return inst
end

local function normalfn()
	return defaultfn("egg")
	
end

local function crackedfn()
   local inst = defaultfn("idle_happy")

    

	--[[if inst.components.cookable then
	inst:RemoveTag("cookable")
    inst:RemoveComponent("cookable")
    end]]
	
    inst.components.hatchable.state = "comfy"

	inst.components.inventoryitem.atlasname = "images/inventoryimages/musha_egg_cracked8.xml"
	
	inst.components.hatchable:StartUpdating()
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 6)
    inst.components.playerprox:SetOnPlayerNear(OnNear)
    --inst.components.playerprox:SetOnPlayerFar(OnFar)
	
    return inst
end

local function cookedfn()
	local inst = commonfn("idle_happy", true, true)
  
    

	inst.cooking_born = true
	
	inst:AddComponent("hatchable")
    inst.components.hatchable:SetOnState(OnHatchState)
    inst.components.hatchable:SetCrackTime(0)
    inst.components.hatchable:SetHatchTime(0)
    inst.components.hatchable:SetHatchFailTime(TUNING.SMALLBIRD_HATCH_TIME * 9999999999999999999)
    
	inst.components.hatchable:StartUpdating()
	
	

    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory_hatched)

    inst.components.inspectable.getstatus = GetStatus

    
 
	
    inst.components.hatchable.state = "comfy"

	inst.components.inventoryitem:ChangeImageName("musha_egg_cracked8")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/musha_egg_cracked8.xml"
	
	inst.components.hatchable:StartUpdating()
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 6)
    inst.components.playerprox:SetOnPlayerNear(OnNear)
    --inst.components.playerprox:SetOnPlayerFar(OnFar)
		
		inst:DoTaskInTime( 1, function() 
inst.components.hatchable.state = "hatch"
CheckHatch(inst) end)

	return inst
end

return Prefab( "common/inventory/musha_egg8", normalfn, assets, prefabs),
		Prefab( "common/inventory/musha_egg_cracked8", crackedfn, assets),
		Prefab("musha_egg_cooked8", cookedfn, assets)
