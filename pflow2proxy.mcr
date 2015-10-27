-- Pflow2Proxy 1.0 - 05/05/14
-- Developed by Midge Sinnaeve
-- www.themantissa.net
-- midge@daze.tv
-- Licensed unde GPL v2

macroScript PFlow2Proxy
	category:"DAZE"
	toolTip:"Convert Particle Flow to Proxies"
	buttonText:"PF2PXY"
	(
		try(destroyDialog ::PFlow2Proxy)catch()
		rollout PFlow2Proxy "Convert Particle Flow to Proxies"
		(
			-- INTERFACE --
			
			fn pfs_filt obj = classof obj == PF_Source
			
			button btn_version "PFlow 2 Proxy 1.0" pos:[135,5] width:115 height:15 border:false
			pickButton pbk_Pflow "Select Particle Flow Source" pos:[5,40] width:245 height:30 filter:pfs_filt
			pickButton pbk_Proxy "Select Proxy Object" pos:[5,80] width:245 height:30
			checkbox chk_delete "Delete Particle System?" pos:[5,117] width:245 height:15 checked:false
			checkbox chk_layer "Create new layer for instanced objects?" pos:[5,145] width:245 height:15 checked:false
			edittext txt_layer "Name:" pos:[5,170] width:245 height:16 enabled:false
			button btn_go "CONVERT" pos:[5,200] width:245 height:45
			
			on chk_layer changed state do txt_layer.enabled = chk_layer.checked
			
			-- FUNCTIONS --
			
			fn convertFlow = with undo off with redraw off
			(
				pfSrc =  getNodeByName pbk_Pflow.text
				pxyObj = getNodeByName pbk_Proxy.text
				
				pxyArray = #()
				
				pfSrc.particleID = 1
				
				while pfSrc.particlePosition != [0,0,0] do
				(
					obj = instance pxyObj
					obj.transform = pfSrc.particleTM
					obj.wirecolor = pxyObj.wirecolor
					pfSrc.particleID += 1
					append pxyArray obj
				)
				
				if chk_delete.checked == true do delete pfSrc
				
				if chk_layer.checked == true then
				(
					layers = LayerManager.newLayerFromName txt_layer.text
					for i =1 to pxyArray.count do layers.addNode pxyArray[i]
				)
				
			)
			
				
			-- ACTIONS --
			
			on pbk_Pflow picked x do if x != undefined do pbk_Pflow.text = x.name
			on pbk_Proxy picked x do if x != undefined do pbk_Proxy.text = x.name
				
			on btn_go pressed do convertFlow()
			
			on btn_version pressed do messageBox "PFlow 2 Proxy 1.0 - 05/05/14 \n\nDev by Midge Sinnaeve \nwww.themantissa.net \nmidge@daze.tv \nFree for all use and / or modification. \nIf you modify the script, please mention my name, cheers. :)" title:"About PFlow 2 Proxy" beep:false
		)
		createDialog PFlow2Proxy 255 250 50 150 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	)
