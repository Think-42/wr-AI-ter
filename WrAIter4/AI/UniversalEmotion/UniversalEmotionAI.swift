//
//  DeepDivePastAI.swift
//  Thoughts
//
//  Created by Sam on 31.08.23.
//

import SwiftUI
import OpenAI

struct UniversalEmotionAI: AI {
    typealias Input = StoryBeat
    typealias Output = String
    
    static let shared = UniversalEmotionAI()
    static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4_1106_preview
    
    var functionName: String { "analyse_universal_emotions" }
    
    var functions: [ChatFunctionDeclaration] {
        return [
            ChatFunctionDeclaration(
                name: self.functionName,
                description: "Use this function to analyse the core emotion and present creative, emotional impulases for the provided story beat number.",
                parameters:
                    JSONSchema(
                        type: .object,
                        properties: [
                            "core_emotion" : .init(type: .string),
                            "core_emotion_reason" : .init(type: .string),
                            "suggestions_for_enhanced_emotion_1" : .init(type: .string),
                            "suggestions_for_enhanced_emotion_2" : .init(type: .string),
                            "suggestions_for_enhanced_emotion_3" : .init(type: .string),
                            "suggestions_for_enhanced_emotion_4" : .init(type: .string),
                            "suggestions_for_enhanced_emotion_5" : .init(type: .string)
                        ]
                    )
            )
        ]
    }
    
    func systemMessage(for input: Input) -> String {
        return """
# Role
You are an expert screenwriter and to me you are also an coach, helping me to improve the stories i write. I am an expert screenwriter, too, so you can use professional terms and concepts. Really help me here!

# Task
There's a specific story beat in my script that feels underwhelming in terms of its emotional impact. Help me to improve the emotional impact of this particular story beat to really take the story to the next level.

# Approach
0. Take a deep breath and relax.
1. Read the story beat and the surrounding story beats.
2. Then tell me about the core emotion that this story beat in the overaching story is trying to convey. Go deep into the core of the emotion and explain why you feel like this is the core emotion.
3. Give a reason, why you think the underlying core emotion will engage the audience.
4. Provide 5 specific show-dont-tell suggestions on how to change this story beat in a bullet point list to amplify and enhance the emotional intensity of this particular story beat. Make the suggestions extreme and intense. Always give 5 suggestions. Tell me how the story could be made more emotional at this point by providing concrete story elements. Be creative!
"""
    }
    
    func userMessage(for storybeat: Input) -> String {
        var outputString: String = ""
        outputString += storybeat.project!.orderedStoryBeatsDescription
        
        outputString += """

I am searching for the core emotion / creative impulses for the storybeat: \(storybeat.index + 1):
```
\(storybeat.text)
```
"""
        
        return outputString
    }
    
    func decodeResponse(from data: Data) throws -> Output {
        struct Response: Codable {
            let core_emotion: String
            let core_emotion_reason: String
            let suggestions_for_enhanced_emotion_1: String
            let suggestions_for_enhanced_emotion_2: String
            let suggestions_for_enhanced_emotion_3: String
            let suggestions_for_enhanced_emotion_4: String
            let suggestions_for_enhanced_emotion_5: String
        }
        let response = try JSONDecoder().decode(Response.self, from: data)
        return "Core Emotion: " + response.core_emotion + "\n\n" + response.core_emotion_reason + "\n\nHere are some impulses to enhance the emotion:\n- " + response.suggestions_for_enhanced_emotion_1 + "\n- " + response.suggestions_for_enhanced_emotion_2 + "\n- " + response.suggestions_for_enhanced_emotion_3 + "\n- " + response.suggestions_for_enhanced_emotion_4 + "\n- " + response.suggestions_for_enhanced_emotion_5
    }
}
