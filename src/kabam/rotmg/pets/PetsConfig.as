package kabam.rotmg.pets 
{
    import com.company.assembleegameclient.ui.dialogs.*;
    import kabam.rotmg.pets.controller.*;
    import kabam.rotmg.pets.controller.reskin.*;
    import kabam.rotmg.pets.data.*;
    import kabam.rotmg.pets.util.*;
    import kabam.rotmg.pets.view.*;
    import kabam.rotmg.pets.view.components.*;
    import kabam.rotmg.pets.view.dialogs.*;
    import kabam.rotmg.pets.view.petPanel.*;
    import org.swiftsuspenders.*;
    import robotlegs.bender.extensions.commandCenter.api.*;
    import robotlegs.bender.extensions.mediatorMap.api.*;
    import robotlegs.bender.extensions.signalCommandMap.api.*;
    import robotlegs.bender.framework.api.*;
    
    public class PetsConfig extends Object implements robotlegs.bender.framework.api.IConfig
    {
        public function PetsConfig()
        {
            super();
            return;
        }

        public function configure():void
        {
            this.injector.map(kabam.rotmg.pets.controller.ShowPetTooltip).asSingleton();
            this.injector.map(kabam.rotmg.pets.data.PetsModel).asSingleton();
            this.injector.map(kabam.rotmg.pets.controller.NotifyActivePetUpdated).asSingleton();
            this.injector.map(kabam.rotmg.pets.util.PetsViewAssetFactory).asSingleton();
            this.injector.map(kabam.rotmg.pets.data.PetSlotsState).asSingleton();
            this.injector.map(kabam.rotmg.pets.controller.PetFeedResultSignal).asSingleton();
            this.injector.map(kabam.rotmg.pets.util.FeedFuseCostModel).asSingleton();
            this.injector.map(kabam.rotmg.pets.data.PetFormModel).asSingleton();
            this.injector.map(kabam.rotmg.pets.controller.reskin.UpdateSelectedPetForm).asSingleton();
            this.mediatorMap.map(kabam.rotmg.pets.view.PetSkinGroup).toMediator(kabam.rotmg.pets.view.PetSkinGroupMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.AvailablePetsView).toMediator(kabam.rotmg.pets.view.AvailablePetsMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.FeedPetView).toMediator(kabam.rotmg.pets.view.FeedPetMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.FusePetView).toMediator(kabam.rotmg.pets.view.FusePetMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.PetsTabContentView).toMediator(kabam.rotmg.pets.view.components.PetsTabContentMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.petPanel.PetPanel).toMediator(kabam.rotmg.pets.view.components.PetPanelMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.PetInteractionPanel).toMediator(kabam.rotmg.pets.view.components.PetInteractionPanelMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.YardUpgraderPanel).toMediator(kabam.rotmg.pets.view.components.YardUpgraderPanelMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.dialogs.PetPicker).toMediator(kabam.rotmg.pets.view.dialogs.PetPickerMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.PetFeeder).toMediator(kabam.rotmg.pets.view.components.PetFeederMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.PetFuser).toMediator(kabam.rotmg.pets.view.components.PetFuserMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.DialogCloseButton).toMediator(kabam.rotmg.pets.view.components.DialogCloseButtonMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.PetTooltip).toMediator(kabam.rotmg.pets.view.components.PetTooltipMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.PetAbilityDisplay).toMediator(kabam.rotmg.pets.view.components.PetAbilityDisplayMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.YardUpgraderView).toMediator(kabam.rotmg.pets.view.YardUpgraderMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.dialogs.CaretakerQueryDialog).toMediator(kabam.rotmg.pets.view.CaretakerQueryDialogMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.components.FusionStrength).toMediator(kabam.rotmg.pets.view.components.FusionStrengthMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.dialogs.PetPickerDialog).toMediator(kabam.rotmg.pets.view.dialogs.PetPickerDialogMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.dialogs.EggHatchedDialog).toMediator(kabam.rotmg.pets.view.dialogs.EggHatchedDialogMediator);
            this.mediatorMap.map(com.company.assembleegameclient.ui.dialogs.DialogCloser).toMediator(com.company.assembleegameclient.ui.dialogs.DialogCloserMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.dialogs.ClearsPetSlots).toMediator(kabam.rotmg.pets.view.ClearsPetSlotsMediator);
            this.mediatorMap.map(kabam.rotmg.pets.view.PetFormView).toMediator(kabam.rotmg.pets.view.PetFormMediator);
            this.commandMap.map(kabam.rotmg.pets.controller.reskin.ReskinPetRequestSignal).toCommand(kabam.rotmg.pets.controller.reskin.ReskinPetRequestCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.UpdateActivePet).toCommand(kabam.rotmg.pets.controller.UpdateActivePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.UpdatePetYardSignal).toCommand(kabam.rotmg.pets.controller.UpdatePetYardCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.UpgradePetSignal).toCommand(kabam.rotmg.pets.controller.UpgradePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.DeactivatePet).toCommand(kabam.rotmg.pets.controller.DeactivatePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.ActivatePet).toCommand(kabam.rotmg.pets.controller.ActivatePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.AddPetsConsoleActionsSignal).toCommand(kabam.rotmg.pets.controller.AddPetsConsoleActionsCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.OpenCaretakerQueryDialogSignal).toCommand(kabam.rotmg.pets.controller.OpenCaretakerQueryDialogCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.EvolvePetSignal).toCommand(kabam.rotmg.pets.controller.EvolvePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.NewAbilitySignal).toCommand(kabam.rotmg.pets.controller.NewAbilityCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.DeletePetSignal).toCommand(kabam.rotmg.pets.controller.DeletePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.HatchPetSignal).toCommand(kabam.rotmg.pets.controller.HatchPetCommand);
            this.commandMap.map(kabam.rotmg.pets.view.petPanel.ReleasePetSignal).toCommand(kabam.rotmg.pets.controller.ReleasePetCommand);
            this.commandMap.map(kabam.rotmg.pets.controller.reskin.ReskinPetFlowStartSignal).toCommand(kabam.rotmg.pets.controller.reskin.ReskinPetFlowStartCommand);
            this.injector.getInstance(kabam.rotmg.pets.controller.AddPetsConsoleActionsSignal).dispatch();
            return;
        }

        public var injector:org.swiftsuspenders.Injector;

        public var mediatorMap:robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

        public var commandMap:robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;

        public var commandCenter:robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    }
}
