class FindModStart extends EventMutator;

function OnEventManagerCreated(EventManager Manager)
{
	Manager.AddListener(new class'FindModListener');
}

