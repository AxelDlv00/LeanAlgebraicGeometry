# Strategy-critic directive — iter-040

Fresh-view audit of the project's long-arc strategy. Read ONLY these inputs:
- `STRATEGY.md` (verbatim — just updated this iter).
- `references/summary.md` (the reference index).
- The blueprint chapter TITLES + one-line topic each: skim the `\chapter{}`/`\section{}`/top-of-file
  comment of each `blueprint/src/chapters/*.tex` (do NOT read full proofs).

Do NOT read: `PROGRESS.md`, `task_pending.md`, `task_done.md`, `task_results/**`, any `iter/iter-NNN/**`
sidecar, or proof-journal. Your value is seeing the strategy as a fresh mathematician would.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): flat base change i=0 (FBC),
generic flatness (GF), and the Quot/Grassmannian foundations (QUOT), with zero project `sorry` and
kernel-only axioms, names/labels matching the parent so finished work merges back.

## What changed this iter (focus your audit here)
1. **FBC route is now at an explicit FORK.** The conjugate-COMPONENT reframing that was supposed to fuse
   the three proved legs (conj-2b/2c/2d) into a `conjugateEquiv.injective` close has failed across iters
   037–039 (a pre-armed kill-criterion fired). STRATEGY now declares the idiom EXHAUSTED and names two
   fallbacks — (A) element-`ext` reopened with conj-2b/2c/2d as a change-of-rings dictionary, (B) a
   `leftAdjointCompIso` refactor of `_legs` — with an iter-040 api-alignment analogist consult to pick A
   vs B, and NO further conjugate prover round. Question: Is this fork framing sound, or is there a
   structurally different route to `IsIso pushforwardBaseChangeMap` the strategy is missing (e.g. proving
   the affine lemma WITHOUT `gstar_transpose` via the affine tilde-equivalence transport — STRATEGY
   mentions it only as a later escalation)? Is the kill-criterion discipline (stop after 3 iters of one
   idiom) being applied correctly, or is it premature given all three legs are in hand?
2. **QUOT gap1 reframed.** STRATEGY now says every CONSUMER of the gap1 keystone descent is built
   axiom-clean and the sole residual is a decomposed geometric "section-transport producer" (4 named
   sub-gaps a–d). Question: is this an honest single-remaining-build, or does the 4-iter feeder accretion
   suggest a design-shape problem (e.g. the section-transport should be done at the sheaf level once,
   not reassembled per basic open)?

## Standing questions to answer
- Are FBC-A and QUOT-defs "Iters left" estimates (2–5 and 3–7) defensible given the elapsed iters in
  each phase, or is one a sunk-cost trap?
- Does any reference in the index actually back the chosen routes (Stacks `lemma-invert-f-sections` for
  the QUOT producer; the mate/conjugate calculus for FBC), or is the strategy improvising?
- Any structural planning error, hallucinated route, missing prerequisite, or silent assumption.

Return SOUND / CHALLENGE / REJECT per route with concrete reasoning. If you CHALLENGE, name the cheapest
corrective.
