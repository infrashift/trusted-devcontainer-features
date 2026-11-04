---
id: "01a1837a-f766-7836-a597-a6c3c5c48636"
title: "Simplified Technical English"
type: "guide"
tags:
  - "guide"
  - "ste"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:08:38-05:00"
description: "The writing rules for all wiki prose, adapted from ASD-STE100, with bad and good examples from this project."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:08:38-05:00"
status: "draft"
sources:
  - resource: "https://www.asd-ste100.org/"
    title: "ASD-STE100 Simplified Technical English"
---

# Simplified Technical English

Write all prose in this wiki in Simplified Technical English (STE). STE comes from the ASD-STE100 specification. It makes text easy to read for humans, for readers whose first language is not English, and for AI agents.

## Words

1. Use the words in [Terminology](/guides/terminology--01a1837af780.md). Use one word for one thing.
2. Use simple, common words. Write "use", not "utilize". Write "start", not "initiate".
3. Use a verb as a verb. Write "verify the checksum", not "do a verification of the checksum".
4. Do not use phrasal verbs. Write "remove", not "get rid of". Write "find", not "figure out".
5. Do not use slang, idioms or jokes.
6. Write technical names in code font: commands, paths, flags, file names, option names, actor names.

## Sentences

1. Keep a procedure sentence to 20 words or fewer.
2. Keep a descriptive sentence to 25 words or fewer.
3. Write one instruction in one sentence.
4. Use the active voice. Write "The PDP blocks the merge", not "The merge is blocked".
5. Use the articles "a", "an" and "the". Do not drop them to save words.
6. Use the present tense for facts. Use the past tense only for events, with a date.

## Procedures

1. Use a numbered list for steps that occur in sequence.
2. Start each step with a verb in the imperative.
3. Put a warning before the step that it applies to. Give the condition first.

Bad:

> Bump the version in devcontainer-feature.json (and don't forget the dependents if it's bootstrap, or check-fanout will yell at you).

Good:

> 1. Change `version` in `src/<feature>/devcontainer-feature.json`.
>
>    WARNING: If the feature is `bootstrap`, you must also change the version of each feature that depends on it.
> 2. Run `make check-fanout`.

## Descriptive text

1. Write one topic in one paragraph.
2. Keep a paragraph to six sentences or fewer.
3. Put the most important fact in the first sentence.
4. Write the `description` field as one sentence of 25 words or fewer. It is the text that the `index.md` listings and search results show.

Bad:

> So basically the npm feature got folded into nodejs since it was kind of pointless to install npm twice and the bundled one had a ton of advisories anyway.

Good:

> The `nodejs` feature replaces its bundled npm with the version in `npm_version`. Thus the `npm` feature is deprecated.

## Facts and opinions

Keep a recorded fact separate from an analysis. Put your analysis under a heading that says so, for example "Analysis". A reader must know which text is the record.

## Related

* [Wiki conventions](/guides/wiki-conventions--01a1837af79c.md) — how to structure a concept.
* [Guides overview](/guides/guides-overview--01a1837af687.md)
