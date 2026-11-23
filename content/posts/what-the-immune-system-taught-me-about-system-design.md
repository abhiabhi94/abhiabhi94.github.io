---
title: "What the immune system taught me about system design"
date: 2026-11-23T10:00:00+05:30
tags: ["system-design", "biology", "learning"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Your immune system screens every new cell before release, keeps a separate component to stop it attacking itself, and remembers past threats. A developer's notes from one documentary."
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: false
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

I recently watched "Defend", the immune system episode of [*Human: The World Within*](https://www.netflix.com/title/81139212) on Netflix. Somewhere in the middle, I stopped watching it as a biology lesson. It started looking like an architecture diagram.

> I'm a developer, not an immunologist. The biology here is simplified, and every claim links to a source so you can read the real thing.

## First, what's a T cell?

The part that got me was T cells. If, like me, you'd forgotten your school biology:

- T cells are a kind of white blood cell, and one of the main fighters in your immune system ([Cleveland Clinic](https://my.clevelandclinic.org/health/body/24630-t-cells)).
- They're part of the *adaptive* immune system: the part that learns to recognise specific germs, instead of reacting to everything the same way.
- They're made in the bone marrow and mature in the thymus, a small organ in your chest. That's where the "T" comes from.

What surprised me is that T cells don't all do the same job. They split the work into four roles:

| T cell | What it does | What it reminded me of |
|---|---|---|
| **Helper** | Doesn't kill anything. Sends chemical signals that switch other immune cells on. | An orchestrator |
| **Killer** (cytotoxic) | Finds and destroys infected cells and tumour cells. | Workers |
| **Regulatory** | Calms other immune cells down, so the body doesn't attack itself. | Guardrails |
| **Memory** | Stays around after an infection, so the next response is faster. | Warm instances |

Let's go through them one at a time.

## Helpers and killers: separation of concerns

- Helper T cells coordinate the attack, but [don't kill anything themselves](https://my.clevelandclinic.org/health/body/23193-helper-t-cells).
- [Killer T cells](https://my.clevelandclinic.org/health/body/23547-cytotoxic-t-cells) do the killing, usually after a helper's signal switches them on.
- So the cells that give the go-ahead aren't the cells that do the work.
- It's like a control plane and its workers: one layer says "start", the other layer does the job.

Each killer cell also has a very small job:

- It doesn't need to understand the whole infection.
- It only recognises one specific marker: a fragment of a germ's protein that an infected cell shows on its surface.
- One input, one action. That's a narrow interface, and single responsibility taken to the extreme.

## The thymus: tests before release

Before a T cell is let out into the body, the thymus screens it. There are two checks:

1. **Does it work at all?** Can it recognise anything? Most candidates fail here.
2. **Does it attack us?** Cells that react strongly to the body's *own* tissue are removed. This is called negative selection.

The cut is brutal. Only about 5% of developing T cells make it out, according to a [2003 review in Nature Reviews Immunology](https://www.nature.com/articles/nri1085).

To me that's a release pipeline:

- Check 1 is a smoke test: does this thing do anything useful?
- Check 2 is "does it break production?", tested against the real system before it ships.
- Anything that fails is thrown away, not patched.

Computer scientists noticed this too:

- In 1994, Stephanie Forrest and colleagues published [*Self-Nonself Discrimination in a Computer*](https://homeostasis.scs.carleton.ca/~soma/biosec/readings/forrest-virus.pdf).
- It's a virus detector built like the thymus:
  - Generate lots of random bit strings, called "detectors".
  - Throw away every detector that matches your own files, like the thymus throwing away cells that attack the body.
  - Keep checking your files against the detectors that are left. Since none of them matched your files at the start, a match later means a file has changed, for example because a virus modified it.
- It was one of the early papers in what became [artificial immune systems](https://en.wikipedia.org/wiki/Artificial_immune_system).

## Regulatory T cells: guardrails

The thymus isn't perfect, and some cells that can attack your own body slip through. So there's a second layer:

- Regulatory T cells patrol the body and calm other immune cells down.
- When they don't work, the immune system turns on the body, and you get severe autoimmune disease.
- The discovery of these cells won the [2025 Nobel Prize in Physiology or Medicine](https://www.nobelprize.org/prizes/medicine/2025/press-release/).

So the body treats "attacking the wrong thing" as a failure worth its own component. The closest thing in software is a guardrail that sits outside the workers:

- A policy engine or admission controller that can refuse an action, however sure the service asking for it is.
- Rate limiting and backpressure, which slow the rest of the system down when it's running too hot.
- A loose cousin is the [circuit breaker](https://martinfowler.com/bliki/CircuitBreaker.html), which stops a system hammering something that's already failing. That's about overload, not friendly fire, but the instinct is the same: something has to be able to say "stop".

## Memory: warm instances

- After an infection, most of the cells that fought it die off, but some stay as memory cells.
- If the same germ shows up again, the response is faster and stronger.
- The textbook [*Immunobiology*](https://www.ncbi.nlm.nih.gov/books/NBK27158/) uses measles as the example: one infection can protect you for life. It's also roughly why vaccines work.

It's tempting to call this a cache, but the body doesn't store an "answer". It's closer to keeping pre-warmed instances around:

- The first time is slow and expensive (you're sick for a week).
- The next time, the right cells are already there and ready to go.

## Scaling: clonal expansion

When T cells find their target, the ones that match it [multiply into a large population of identical copies](https://www.ncbi.nlm.nih.gov/books/NBK27158/). Once the threat is gone, most of them die off, and the memory cells stay.

That's autoscaling:

- Scale out exactly the thing that's needed, under load.
- Scale back in when it's quiet.
- Keep a few instances warm for next time.

## What about dynamic programming and RL?

Memory and learning from experience sound a lot like two ideas from computer science: dynamic programming and reinforcement learning (RL). That's where my head went first. But when I looked closer, they mostly don't fit, and I think that's worth saying:

- **Dynamic programming** stores answers to sub-problems so you don't solve them twice. Immune memory feels like that, but it's really the memory point again. Infections aren't sub-problems of some bigger problem.
- **Reinforcement learning** has an agent that tries actions and learns from rewards. The immune system doesn't have one agent learning. It has millions of random variants, and the ones that match get copied. That's *selection*, closer to an evolutionary algorithm than to RL.
- Immunologists call this [clonal selection](https://en.wikipedia.org/wiki/Clonal_selection), and computer scientists borrowed it too: the clonal selection algorithm is one of the standard [artificial immune system](https://en.wikipedia.org/wiki/Artificial_immune_system) algorithms.

So the better analogy for the "learning" part is "generate lots of options, keep what works, copy it". It's an old idea in computing, and the body was doing it first.

## The joy of it

Nobody designed this, and still it ended up with:

- an orchestrator that doesn't do the work,
- workers with one narrow job,
- a release pipeline that throws away bad builds,
- guardrails that sit outside the workers,
- warm instances for repeat threats,
- and autoscaling.

We reinvented most of these in software, usually after something broke. It makes me wonder what else is sitting in a biology textbook that we haven't noticed yet.
