require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.PICKUP, "action"),
    ActionHandler(ACTIONS.STEAL, "action"),
    ActionHandler(ACTIONS.PICK, "action"),
    ActionHandler(ACTIONS.HARVEST, "action"),
    
	ActionHandler(ACTIONS.CHOP, "chop"),
	ActionHandler(ACTIONS.MINE, "mine"),			 
	
}


local events=
{
    CommonHandlers.OnStep(),
    --CommonHandlers.OnLocomote(true,true),
 	
	EventHandler("locomote", function(inst) 
        if not inst.sleep_on then --inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
			local follow = inst.follow
				if wants_to_move and not follow then
					local working_food = inst.working_food 
					local working_item = inst.pick1
					local should_run = inst.components.locomotor:WantsToRun()
					if should_run or working_food or working_item then
						inst.sg:GoToState("run")
					else
						inst.sg:GoToState("walk")
					end
				elseif wants_to_move and follow then	
					inst.sg:GoToState("run")
				else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),
		
	
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
	
	EventHandler("doaction", 
        function(inst, data) 
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.PICKUP then
                    inst.sg:GoToState("action", data.target)
                end
            end
        end),
	EventHandler("doaction", 
        function(inst, data) 
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.STEAL then
                    inst.sg:GoToState("action", data.target)
                end
            end
        end),
	EventHandler("doaction", 
        function(inst, data) 
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.PICK then
                    inst.sg:GoToState("action", data.target)
                end
            end
        end),
	EventHandler("doaction", 
        function(inst, data) 
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.HARVEST then
                    inst.sg:GoToState("action", data.target)
                end
            end
        end),	
	EventHandler("doaction", 
        function(inst, data) 
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.CHOP then
                    inst.sg:GoToState("chop", data.target)
                end
            end
        end),
	EventHandler("doaction", 
        function(inst, data) 
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.MINE then
                    inst.sg:GoToState("mine", data.target)
                end
            end
        end),
		
	EventHandler("doattack", function(inst, data)
          if not inst.components.health:IsDead() and not inst.ranger and not inst.ranger2 and not inst.ranger3 then 
            inst.sg:GoToState("attack", data.target)
        elseif not inst.components.health:IsDead() and inst.ranger then 
            inst.sg:GoToState("attack2", data.target)
		elseif not inst.components.health:IsDead() and inst.ranger2 then 
            inst.sg:GoToState("attack2", data.target) 
		elseif not inst.components.health:IsDead() and inst.ranger3 then 
            inst.sg:GoToState("attack2", data.target)
        end 
    end),
    --EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() then inst.sg:GoToState("attack", data.target) end end),
    EventHandler("death", function(inst)
        --if inst.components.rideable == nil or not inst.components.rideable:IsBeingRidden() then
            inst.sg:GoToState("death")
        --end
    end),
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
    EventHandler("heardhorn", function(inst, data)
        if not inst.components.health:IsDead()
           and not inst.sg:HasStateTag("attack")
           and data and data.musician then
            inst:FacePoint(Vector3(data.musician.Transform:GetWorldPosition()))
            inst.sg:GoToState("bellow")
        end
    end),
    EventHandler("loseloyalty", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("shake") end end),
    EventHandler("eat", function(inst, data) 
        if not inst.components.health:IsDead()
           and not inst.sg:HasStateTag("attack") then
           inst.sg:GoToState("eat", data)
       end
    end),
    EventHandler("refusedrider", function(inst, data)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
            inst.sg:GoToState("matingcall")
        end
    end),
    EventHandler("brushed", function(inst, data)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            if data.numprizes > 0 then
                inst.sg:GoToState("pleased")
            else
                inst.sg:GoToState("meh")
            end
        end
    end),
}

local states=
{
-------------------------------------------------------------------
-------------------------------------------------------------------
  State{
        name = "action",
        
        onenter = function(inst)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("shave")
  
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.AnimState:PlayAnimation("atk") end ),
            TimeEvent(14*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/pop") end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },	
	
 --[[State{
        
        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/pop")
			inst.sg:GoToState("attack")
        end,
        onexit = function(inst)
            inst:PerformBufferedAction()
        end,
        events=
        {
            EventHandler("animover", function (inst)
                inst.sg:GoToState("idle")
            end),
        }
    }, ]]
   
-------------------------------------------------------------------
   State{
        name = "chop",
        tags = {"chopping"},
        
        onenter = function(inst)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("shave")
  
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.AnimState:PlayAnimation("atk") end ),
            TimeEvent(14*FRAMES, function(inst) inst:PerformBufferedAction() end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
-------------------------------------------------------------------
   State{
        name = "mine",
        tags = {"mining"},
        
        onenter = function(inst)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("shave")
  
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.AnimState:PlayAnimation("atk") end ),
            TimeEvent(14*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/wilson/use_pick_rock") end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },	


-------------------------------------------------------------------

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, pushanim)
            inst.components.locomotor:StopMoving()
            if inst.hairGrowthPending then
                inst.sg:GoToState("hair_growth")
            elseif inst.growUpPending then
                inst.sg:GoToState("grow_up")
            elseif inst.domesticationPending then
                inst.sg:GoToState("become_domesticated")
            else
                if pushanim then
                    inst.AnimState:PushAnimation("idle_loop", true)
                else
                    inst.AnimState:PlayAnimation("idle_loop", true)
                end
                
                inst.sg:SetTimeout(1 + 1*math.random())
            end
        end,

        timeline = {
            TimeEvent(5*FRAMES, function(inst) inst.didalertnoise = nil end),
        },

        ontimeout=function(inst)
            local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
            if inst.components.rideable and inst.components.rideable:IsSaddled() and inst.components.domesticatable and inst.components.domesticatable:GetObedience() < TUNING.BEEFALO_KEEP_SADDLE_OBEDIENCE then
                inst.sg:GoToState("shake_off_saddle")
            elseif not inst:HasTag("baby") 
                and ((herd and herd.components.mood and herd.components.mood:IsInMood())
                     or (inst.components.mood and inst.components.mood:IsInMood())) then
                if math.random() < .5 then
                    inst.sg:GoToState("matingcall")
                else
                    inst.sg:GoToState("tailswish")
                end
            else
                local rand = math.random()
                if inst.components.hunger and inst.components.hunger:GetPercent() > 0 then
                    --if rand < .75 then
					if inst.graze then
                        inst.sg:GoToState("graze")
						inst.components.hunger:DoDelta(3)
						inst.components.health:DoDelta(6)
                    elseif rand < .75 then
                        inst.sg:GoToState("shake")
                    else
                        inst.sg:GoToState("bellow")
                    end
                else
                    if rand < .5 then
                        --inst.sg:GoToState("graze_empty")
						inst.sg:GoToState("flatulate")
                    elseif rand < .75 then
                        inst.sg:GoToState("beg")
                    else
                        inst.sg:GoToState("bellow")
                    end
                end
            end
        end,
    },
    
    State{
        name = "shake",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shake")
        end,
       
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "badfood",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("intestinal_cramp")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "shake_off_saddle",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shakesaddle_off")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/harvest_berries")
            --inst.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/shake_off")
        end,

        timeline=
        {
            TimeEvent(24*FRAMES, function(inst)
                inst.components.rideable:SetSaddle(nil, nil)
            end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "regurgitate",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("vomit")
            --inst.SoundEmitter:PlaySound("dontstarve/beefalo/puke_start")
        end,

        timeline=
        {
            TimeEvent(14*FRAMES, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/beefalo/puke_out")
               -- local loot = SpawnPrefab("spoiled_food")
               -- local x,y,z = inst.Transform:GetWorldPosition()
               -- loot.Transform:SetPosition(x, 1.0, z)
                --loot.components.inventoryitem:AddMoisture(50)
            end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "pleased",
        tags = {"canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("brush")
            --inst.SoundEmitter:PlaySound("dontstarve/beefalo/positive")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "meh",
        tags = {"canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shake")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "beg",
        tags = {"canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("beg_pre")
            inst.AnimState:PushAnimation("beg_loop")
            inst.AnimState:PushAnimation("beg_loop")
            inst.AnimState:PushAnimation("beg_pst", false)
        end,

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/bellow") end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("actual_alert") end),
        },
    },

    State{
        name = "bellow",
        tags = {"canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("bellow")
            inst.SoundEmitter:PlaySound(inst.sounds.grunt)
        end,
       
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "matingcall",
        tags = {},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("mating_taunt1")
            inst.SoundEmitter:PlaySound(inst.sounds.yell)
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "tailswish",
        tags = {},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("mating_taunt2")
        end,
        
        timeline=
        {
            TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swish) end),
            TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swish) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name="graze",
        tags = {"canrotate","eating"},
        
        onenter = function(inst, data)
		--inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("graze_loop", true)
            inst.sg:SetTimeout(1+math.random()*5)
        end,
        
        ontimeout= function(inst)
            inst.sg:GoToState("idle")
        end,

    },

    State{
        name="graze_empty",
        tags = {"canrotate"},
        
        onenter = function(inst, data)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("graze2_pre")
            inst.AnimState:PushAnimation("graze2_loop")
            inst.sg:SetTimeout(1+math.random()*5)
        end,
        
        ontimeout= function(inst)
            inst.AnimState:PlayAnimation("graze2_pst")
            inst.sg:GoToState("idle", true)
        end,

    },

    State{
        name="eat",
        tags = {"busy"},

        onenter = function(inst, data)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("graze_loop", true)
            --inst.SoundEmitter:PlaySound("dontstarve/beefalo/eat_treat")
			
           --[[ if data.food ~= nil and data.food.components.edible ~= nil then
                inst.sg.statemem.badfood = data.food.components.edible.hungervalue < 0 or data.food.components.edible.healthvalue < 0
                inst.sg:SetTimeout(Remap(math.abs(data.food.components.edible.hungervalue), TUNING.CALORIES_TINY, TUNING.CALORIES_SUPERHUGE, 0.4, 8.0) + math.random()*0.3)
            else
                inst.sg:SetTimeout(2.0+math.random()*2.0)
            end
            inst.sg.statemem.full = data.full]]
        end,

        timeline =
        {
            TimeEvent(28*FRAMES, function(inst)  
			--inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") 
			end),
            TimeEvent(56*FRAMES, function(inst) 
			--inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") 
			end),
            TimeEvent(84*FRAMES, function(inst)  
			--inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") 
			end),
            TimeEvent(112*FRAMES, function(inst) 
			--inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") 
			end),
        },

        ontimeout= function(inst)
            if inst.sg.statemem.full then
                inst.sg:GoToState("regurgitate")
            else
                if inst.sg.statemem.badfood then
                    inst.sg:GoToState("badfood")
                elseif inst.components.hunger:GetPercent() > 0.8 then
                    inst.sg:GoToState("flatulate")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end,

    },

    State{
        name="flatulate",
        tags = {"busy"},

        onenter = function(inst, data)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("fart")
        end,

        timeline =
        {
            TimeEvent(9*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("dontstarve/beefalo/fart")
			inst.SoundEmitter:PlaySound(inst.sounds.swish)	end),
            TimeEvent(10*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("dontstarve/beefalo/tail_swish_fast") 
			inst.SoundEmitter:PlaySound(inst.sounds.swish)	end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },

    },


    -- The "alert" state name is hardcoded into the FaceEntity behaviour, but since we want to beg sometimes instead...
    State{
        name = "alert",
        tags = {"idle", "canrotate", "alert"},
        
        onenter = function(inst)
           -- if inst:ShouldBeg() then
              --  inst.sg:GoToState("beg")
           -- else
                inst.sg:GoToState("actual_alert")
           -- end
        end,
    },
    
    State{
        name = "actual_alert",
        tags = {"idle", "canrotate", "alert"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            if not inst.didalertnoise then
                inst.SoundEmitter:PlaySound(inst.sounds.curious)
                inst.didalertnoise = true
            end
            if not inst.AnimState:IsCurrentAnimation("alert_idle") then
                inst.AnimState:PlayAnimation("alert_pre")
                inst.AnimState:PushAnimation("alert_idle", true)
            end

            inst.sg:SetTimeout(2 + 2*math.random())
        end,
        
        ontimeout=function(inst)
            if inst.components.rideable and inst.components.rideable:IsSaddled() and inst.components.domesticatable and inst.components.domesticatable:GetObedience() < TUNING.BEEFALO_KEEP_SADDLE_OBEDIENCE then
                inst.sg:GoToState("shake_off_saddle")
            elseif inst.domesticationPending then
                inst.sg:GoToState("become_domesticated")
         --   elseif inst:ShouldBeg() then
         --       inst.sg:GoToState("beg")
            else
                inst.sg:GoToState("actual_alert")
            end
        end,
    },

    State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            --inst.SoundEmitter:PlaySound(inst.sounds.angry)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
      
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    State{
        name = "attack2",
        tags = {"attack", "busy"},

		onenter = function(inst)
			   
	        inst.SoundEmitter:PlaySound(inst.sounds.angry)
            inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
            inst.components.locomotor:StopMoving()
     
			inst.AnimState:PlayAnimation("shave")
			
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:StartAttack() 
			inst.AnimState:PlayAnimation("atk") end ),
            TimeEvent(14*FRAMES, function(inst) inst.components.combat:DoAttack() inst.AnimState:SetBloomEffectHandle( "" ) end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    
    },	
	
    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
		if inst.components.container then
        inst.components.container:Close()
		inst.components.container:DropEverything() end
		if inst.components.inventory and not inst.components.poisonable then
		inst.components.inventory:DropEverything() end
		
            inst.SoundEmitter:PlaySound(inst.sounds.yell)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
			inst.yamche_leader = false
			inst:RemoveTag("yamche_leader")
            inst.components.lootdropper:DropLoot(inst:GetPosition())

        end,
    },

    State{
        name = "become_domesticated",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("transform") 
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_pop")
            inst.domesticationPending = false
        end,

        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) SpawnPrefab("beefalo_transform_fx").Transform:SetPosition(inst.Transform:GetWorldPosition()) end),
            TimeEvent(11*FRAMES, function(inst) inst:UpdateDomestication() end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "grow_up",
        tags = {"busy"},

        onenter = function(inst)
	if inst.components.container then
	inst.components.container:Close()
	inst.components.container:DropEverything() 
	inst:RemoveComponent("container")
	end
	if inst.components.inventory then 
	--inst:RemoveTag("aquatic")
	--inst.components.inventory:DropEverything() 
	--inst:RemoveComponent("inventory")
	end
			inst.components.talker:Say("[Grow up]")
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hair_growth_pre")
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_vocal")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.components.growable:SetStage(inst.components.growable:GetNextStage())
                inst.growUpPending = false
				inst.level = 0
                inst.sg:GoToState("grow_up_pop")
            end),
        },
    },

    State{
        name = "grow_up_pop",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hair_growth")
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_pop")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },


    State{
        name = "hair_growth",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hair_growth_pre")
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_vocal")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("hair_growth_pop") end),
        },
    },

    State{
        name = "hair_growth_pop",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hair_growth")
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_pop")
            if inst.components.beard then
                    inst.AnimState:SetBuild("beefalo_build")
                inst.components.beard.bits = 3
            end
            if inst.components.brushable then
                inst.components.brushable:SetBrushable(true, true)
            end
            inst.hairGrowthPending = false
           -- inst:ApplyBuildOverrides(inst.AnimState)
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "shaved",
        tags = {"busy", "sleeping"},
        
        onenter = function(inst)
          --  inst:ApplyBuildOverrides(inst.AnimState)
            inst.AnimState:PlayAnimation("shave")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                    inst.sg:GoToState("sleeping")
                else
                    inst.sg:GoToState("wake")
                end
            end),
        },
    },

    State{
        name = "refuse",
        tags = {"busy"},

        onenter = function (inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shake")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
   
    State
    {
        name = "run_start",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            local hastarget = inst.components.combat ~= nil --and inst.components.combat:HasTarget()
            inst.AnimState:PlayAnimation(hastarget and "run_pre" or "run2_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("run")
            end),
        },
    },
   
    State
    {
        name = "run",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            local hastarget = inst.components.combat ~= nil --and inst.components.combat:HasTarget()
            inst.AnimState:PlayAnimation(hastarget and "run_loop" or "run2_loop", true)
            --inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
			inst.sg:SetTimeout(2 + 1*math.random())
        end,

        timeline = {
            TimeEvent(1*FRAMES, function(inst) inst.didalertnoise = nil end),
            TimeEvent(5*FRAMES, PlayFootstep),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end,
    },
   
    State
    {
        name = "run_stop",
        tags = { "idle" },

        onenter = function(inst) 
            inst.components.locomotor:StopMoving()
            local hastarget = inst.components.combat ~= nil --and inst.components.combat:HasTarget()
            inst.AnimState:PlayAnimation(hastarget and "run_pst" or "run2_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
}

--#TODO: Special walk states for when stomach is empty, use that graze walk loop
CommonStates.AddWalkStates(
    states,
    {
        walktimeline =
        {
            TimeEvent(1*FRAMES, function(inst) inst.didalertnoise = nil end),
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk) end),
            TimeEvent(40*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk) end),
        }
    })
	
CommonStates.AddRunStates(
    states,
    {
        runtimeline = 
        { 
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk) end),
        }
    })	

CommonStates.AddSimpleState(states,"hit", "hit")
CommonStates.AddFrozenStates(states)

CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
    
    
return StateGraph("mini_arong", states, events, "idle", actionhandlers)

