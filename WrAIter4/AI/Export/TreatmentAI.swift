//
//  EmotionAI.swift
//  Thoughts
//
//  Created by Sam on 13.08.23.
//

import SwiftUI
import OpenAI

struct TreatmentAI: AI {
    typealias Input = Project
    typealias Output = String
    
    static let shared = Self()
    static var defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4_1106_preview
    
    var functionName: String { "generate_treatment" }
    
    var functions: [ChatFunctionDeclaration] {
        return []
    }
    
    func systemMessage(for input: Input) -> String {
        return """
# Role
You're an expert screenwriter. And you have been hired to write a treatment for a movie. I am the producer and I will give you the storybeats, I also am highly experienced in writing screenplays.

# Goal
Write a treatment for the storybeats i give you.

# Approach
1. Take a deep breath and relax.
2. Read the storybeats.
3. Transform the story beats into a professional treatment by also fleshing out the story where more details are necessary.

# Guidlines
- Apple the "show, dont tell" principle
- make the concept and premise super clear
- provide strong character descriptions
- Stick to the facts provided in the story beats. Dont invent new story elements, however you can flesh exsiting ideas out.


Reply in markdown format and make headings where appropriate:
```md

```

# Perfect Example Treatment of the movie E.T.
```md
E.T. II NOCTURNAL FEARS
In the night sky there is an emotion churning about. The stars twinkle blankly, expressionless as if to say that some thing is wrong. There is a slight breeze disturbing the the treetops - or is it?
Through gnarled branches we gaze upon a familiar sight. In what seemed like only the blink of an eye, something has penetrated the night sky and nearly avoided our attention. A small noise, followed by streaks of stray light, further acknowledge its presence. A door is being opened on the giant ornamental Mothership now resting in the forest clearing.
A door opens and extends outward to make a ramp. Light pours from within and a figure emerges as a silhouette. The creature moves in a familiar fashion - a waddle.
School has now come to an end for Elliott, Michael, Gertie and their many friends. For most youngsters, summer is something to look forward to. This is not the case for a handful of children this summer! Summer is, unfortunately, a continuation and concentration of feelings and thought the previous months only hinted to. For these few kids, summer premises only one thing...LONLINESS. This is the first of many summers without their little alien friend, nicknamed E.T.. Hard as it is, the children cope...
Elliott, Michael and Gertie are closer to one another since E.T. came into their lives. They have a special sort of relationship now. But as always, time tends to blur memories and Elliott's mother, Mary, is still waiting for that process to begin. So far, however, E.T. is as popular today as he ever was!
The spaceship, nestled in the forest clearing surrounded by massive Redwoods, seems to be showing signs of life. Movement can be detected within the ship.
The aliens onboard are EVIL. They have landed on Earth in response to distress signals designating its present coordinates. These aliens are searching for a stranded extraterrestrial named Zrek, who is sending a call for "Help".
The evil creatures are carnivorous. Their leader, Korel, commands his crew to disperse, into the forest to acquire food. As the squat aliens leave the gangplank, each one emits a hypnotic hum which has a paralyzing effect on the surrounding wildlife. These creatures are an albino fraction (nutation) of the same civilization E.T. belongs to. The two separate groups have been at war for decades!
Morel approaches the top of the gangplank and raises his frail arms outward as his yellow heart-light summons his crew back to the Mothership. For a moment the aliens are paralyzed themselves. The tiny creatures eventually look up with their large, expressive red eyes and begin their orderly processional back up into the spaceship.
Inside the craft is a vast assortment of large plants and animal-like beasts in cages of light - obviously specimens from past voyages.
At Elliott’s home we see him climbing onto his roof to check E.T.’s COMMUNICATOR, which has been anchored down and sending messages into space ever since E.T. left Earth.
Elliott's father returned from New Mexico months before and filed for divorce and moved back to New Mexico. But Elliott's family has seen harder times. And the fact that Mary has been dating Dr. Keys, since they met just before E.T. left, has eased the strain considerably.
One thing is certain...everybody under this house­ hold's roof has something in common - E.T.! Keys has told his story time and time again about his first meet­ing with the tiny, confused E.T.. It is a story full of emotion, surprise and mystery. Keys never plays down how important that experience was to the direction his life took from then oh. Keys admits his life ambitions were channeled toward more positive and rewarding goals. He didn't continue to live in a dream-world of hope that he would one day meet his space friend again, like he fears Elliot and his friends are now. Keys insists he chose to pursue medicine and science because of E.T..
Recently, Elliott has been sensing something he cannot explain. His umbrella COMMUNICATOR is reacting strangely now. He thinks it could be receiving a message from space!
In his room, Elliott is searching for something. On his wall is the Polaroid snapshot of himself with Michael and E.T. on Halloween night. Above his bed we see E.T.'s clay planets suspended by wire from the ceiling. Elliott emerges from the closet with a pot. His face becomes sad. The Garanium is still dead. He puts the pot on his dresser and sits on his bed, thinking.
Later, Elliot jumps up happy and races through his house. He finds Michael and Gertie and makes them promise their "most excellent promise" that they will tell nobody what they are about to do. Having finished that, Elliott calls his D&D buddies Steve, Tyler and Greg and tells them to ride their bicycles to the forest clearing because E.T. could be coming back!
There have been numerous reports of unexplained cattle mutilations in the surrounding countryside.
At the clearing we sense danger. We see shadows and undefined forms lurking in the nearby forest. Night is falling and in the distance we hear a commotion. Elliot and his friends are converging on the clearing unaware of any trouble. They arrive and dismount, their bicycles.
In awe, everyone gazes upon the dark contours of the massive space machine. Suddenly the figure of Korel appears in an illuminated porthole. Telepathically Korel speaks to the children asking the whereabouts of the fugitive alien, Zrek. The children reply honestly that..."He's gone home!". Korel becomes angry, believing , that they are lying.
When the children regain their senses, they are surrounded by the evil alien creatures who were hiding in the forest. The creatures are carrying some kind of dagger. Elliott advances in a friendly gesture but barely escapes being bitten, or even killed, by the alien's razor-sharp teeth! Several of the aliens bare their fangs from time to time to show they mean business. Korel orders that the children be brought aboard. Reluctantly Elliott and his friends follow.
In the hours that follow, Elliott and his companions are questioned extensively. But the aliens will not accept the truth in their responses. While one child is interrelated, another is being examined. Gertie is crying and calling for Mary and E.T. for help. The others endure (as their war-ginning experiences have taught them).
At Elliott's home, Mary is arriving from an extended date with Dr. Keys. They enter the empty house and proceed to investigate further why nobody is home. It is past 11:00p.m..
It is now time for Elliott to be questioned. The aliens show no mercy when he replies with the truth. The questioning process intensifies when they learn from his memory that he has dealt directly with Zrek. The pain is tremendous for Elliott and he breaks down and begins screaming for E.T.'s help. Elliott blacks out - but the echoes of his last cry can be heard from a distance. At this point we follow, upward, the echoing cry for E.T. into the cosmos where the painfull cry seems to die.
In the meantime, Keys and Mary decide not to call the police yet. They hear a strange noise coming from - somewhere. They finally realize that the sound is coming from the roof.
Mary leads the way to Elliott’s room where there is a trap door leading to the attic. From there, Keys climbs out a window and up to the rooftop.
He witnesses a bizarre sight...the COMMUNICATOR is vibrating crazily and rotating to a new position. The keyboard read-out is repeating the same entry: "E.T. HELP ELLIOTT SOON”.
Keys calls Mary to the roof. When she arrives to read the message, they embrace and go back through the attic, into Elliott’s room. Mary turns around and sees the Geranium blooming to life. She lets out a feeble yelp and begins to cry. Keys and Mary are now aware of what has been happening. They go to their car and head for the forest clearing.
Elliott is mentally and physically drained now. Because he is no longer on use to the aliens, they carry his limp body to a light cage where Michael and Gertie are already resting.
Suddenly we hear a strange resonating hum throughout the ship, yet it is not coming from within the ship.
All the evil aliens freeze. A hatch opens to reveal E.T. with his glowing finger raised and his heart-light pulsating.
Elliott awake s immediately. E.T. advances toward the captives and deactivates the light cages. He and Elliott embrace with tears in their eyes.
Elliott, Michael, Gertie, Steve, Tyler and Greg leave the EVIL Mothership and wait for E.T. to come out after re-programming the alien’s navigation controls. E.T. exits the ship and rejoins his faithful friends.
Soon after, Mary and Keys arrive and are reunited again with the magical little alien named E.T.. After saying their tearful goodbyes, E.T.’s own Mothership descends from the Heavens to take the place of the evil ship that is now enroute to a remote corner of the galaxy.
There is HOPE in everyone's eyes as they all again, behold the picturesque departure of their favorite alien. Dreams can come true!
-THE END-
```
"""
    }
    
    func userMessage(for input: Input) -> String {
        var string: String = ""
        string += "My storybeats are:\n\(input.orderedStoryBeats.description)"
        return string
    }
    
    func decodeResponse(from data: Data) throws -> String {
        return String(data: data, encoding: .utf8)!
    }
}
