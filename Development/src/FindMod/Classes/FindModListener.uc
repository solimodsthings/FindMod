//[Find Mod for Himeko Sutori (2021)]

// Lets you do searches in the lance management
// screen via the command line. Characters that
// don't match your search are filtered/greyed out.
//
// Examples commands:
// > TellMod Find Aya    
// > TellMod Find Knight 
// > TellMod Find "Healing Burst" 
// > TellMod Find Reset
// 

class FindModListener extends EventListener;

struct PawnHighlight
{
    var RPGTacPawn Character;
    var ParticleSystemComponent Particle;
};

var array<PawnHighlight> Highlights;
var string DefaultParticle;
var float Morning;
var float Night;
var bool InSquadMenu;

// Override to handle search queries receive through
// command line.
function OnReceiveMessage(string Message)
{
    local RPGTacPawn TargetPawn;

    if(InSquadMenu)
    {
        ClearHighlights();

        if(Locs(Message) == "clear" || Locs(Message) == "reset")
        {
            foreach Manager.Army(TargetPawn)
            {
                TargetPawn.CheckForLevelUpStar();
                SetFaded(TargetPawn, false);

                if(TargetPawn.bSquadLeader)
                {
                    TargetPawn.SpawnLeaderHeraldry(Manager.CoatOfArms);
                }
            }
        }
        else
        {
            foreach Manager.Army(TargetPawn)
            {
                TargetPawn.ClearLevelUpStar();
                TargetPawn.DestroyLeaderHeraldry();

                if(HasMatch(TargetPawn, Message))
                {
                    SetFaded(TargetPawn, false);
                    // AddHighlight(TargetPawn); // Will re-enable this once a suitable particle effect is found
                }
                else
                {
                    SetFaded(TargetPawn, true);
                }
            }
        }
    }
}

// Override to ensure search queries are only accepted
// when player is in lance management screen.
function OnCauseEvent(optional Name event)
{
    local RPGTacPawn TargetPawn;

    if(event == 'SquadMenu')
    {
        InSquadMenu = true;
    }
    else if(event == 'ReturnToPauseMenu')
    {
        InSquadMenu = false;

        ClearHighlights();

        foreach Manager.Army(TargetPawn)
        {
            TargetPawn.bIsBowing = false;
        }
    }
}

// Used to make matching characters more visible than
// non-matching ones.
private function SetFaded(RPGTacPawn TargetPawn, bool IsFaded)
{
    if(IsFaded)
    {
        TargetPawn.bIsBowing = true;
        TargetPawn.PawnSprite.ConsoleMaterial.SetScalarParameterValue('Time', Night);
    }
    else
    {
        TargetPawn.bIsBowing = false;
        TargetPawn.PawnSprite.ConsoleMaterial.SetScalarParameterValue('Time', Morning);
    }
    
}

// Used to add a particle effect on matching characters.
private function AddHighlight(RPGTacPawn TargetPawn)
{
    local PawnHighlight Highlight;

    Highlight.Character = TargetPawn;
    Highlight.Particle = Manager.World.MyEmitterPool.SpawnEmitter(
        ParticleSystem(DynamicLoadObject(DefaultParticle, class'ParticleSystem')), 
        TargetPawn.Location, 
        TargetPawn.Rotation, 
        TargetPawn
    );

    Highlight.Particle.SetScale(0.50);
    Highlights.AddItem(Highlight);
}

// Clears all particle effects used to highlight matching characters.
private function ClearHighlights()
{
    local PawnHighlight Highlight;

    foreach Highlights(Highlight)
    {
        Highlight.Particle.DeactivateSystem();
        Highlight.Character.DetachComponent(Highlight.Particle);
    }

    Highlights.Length = 0;
}

// Main search function. Currently only checks character names,
// (current) class name, abilities, and reactions.
private function bool HasMatch(RPGTacPawn TargetPawn, string Keyword)
{
    local CardCount Ability;
    local ReactionCount Reaction;

    Keyword = Locs(Keyword);

    if(Locs(TargetPawn.CharacterName) == Keyword)
    {
        return true;
    }

    if(Locs(TargetPawn.CharacterClasses[TargetPawn.CurrentCharacterClass].ClassName_Localized) == Keyword)
    {
        return true;
    }

    foreach TargetPawn.NewAbilityList(Ability)
    {
        if(Locs(Ability.Card.CardName_Localized) == Keyword)
        {
            return true;
        }
    }

    foreach TargetPawn.UniqueReactionList(Reaction)
    {
        if(Locs(Reaction.Reaction.ReactionName_Localized) == Keyword)
        {
            return true;
        }
    }

    // TODO: "CanLearn:<Keyword>"
    /*
    //local RPGTacCharacterClass TargetClass;
    //local RPGTacCharacterClass_LevelUpCard TargetCard;
    foreach TargetPawn.CharacterClasses(TargetClass)
    {
        foreach TargetClass.LevelUpCardDeck(TargetCard)
        {
            if(Locs(TargetCard.CardName_Localized) == Keyword)
            {
                return true;
            }
        }
    }
    */

    return false;
}

DefaultProperties
{
    Id = "Find"
    InSquadMenu = false
    Morning = 8.0
    Night = 22.0
    DefaultParticle = "RPGTacParticles.Particles.RisingSparkleGoldContinuous"
}