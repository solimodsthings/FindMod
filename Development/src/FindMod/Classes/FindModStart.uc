//[Find Mod for Himeko Sutori (2021)]

class FindModStart extends ModStart;

function OnStart(CorePlayerController Core)
{
	Core.AddPlugin(new class'FindCommand');
}

