# Strategy-critic directive — slug `ts242`

You are a fresh-context critic of the project's long-arc strategy. Read ONLY the following; do not read
iter sidecars, task files, PROGRESS.md, or any per-iter narrative.

## Read
1. `/.archon/STRATEGY.md` (verbatim — the current strategy).
2. `/references/summary.md` (the reference index).
3. The blueprint chapter list: `blueprint/src/chapters/*.tex` — read only each chapter's title line / first
   `\section` or top comment to get a one-line topic per chapter. Do NOT read chapter bodies.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: an Albanese/Jacobian object `J := Pic⁰_{C/k}` uniform over
the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k` (`[Field k]` only). The
near-term PRIMARY objective (USER directive) is a complete proof of `Pic_{C/k}` representability (A.2.c),
proved bottom-up. End-state: zero inline `sorry` in the dependency cone of the nine protected declarations,
0 project axioms.

## What changed this iter (the thing to scrutinize)
The A.1.c substrate `IsInvertible.pullback` Phase 2 (`pullbackTensorIso : f^*(M⊗N) ≅ f^*M ⊗ f^*N`) had its
RECIPE changed. The previous plan was "build a comparison map `pullbackObjTensorToTensor` and prove it iso
by a local-chart finality argument" (premised on the abstract left-adjoint pullback having no sectionwise
formula, and `Adjunction.leftAdjointOplaxMonoidal` being absent from Mathlib). A read-only Mathlib analogist
consult found that premise STALE: the doctrinal-adjunction tensorator machinery IS in the pinned Mathlib
(PR #36599), and the right route is to MIRROR Mathlib's own construction — build a concrete strong-monoidal
pullback `P = sheafify∘(sectionwise extendScalars)` (tensorator `distribBaseChange` + the landed
`sheafifyTensorUnitIso`), prove `P ⊣ pushforward`, and transport `P.Monoidal` to the abstract
`Scheme.Modules.pullback` via `Adjunction.leftAdjointUniq` (the same device that closed the iter-217
`tensorObj_restrict_iso`). Phase 1 (`pullbackUnitIso`) is already DONE.

## What I need from you
- Is the revised A.1.c Phase 2 route SOUND as the path to `IsInvertible.pullback`? In particular: is
  "build a concrete monoidal model `P` and transport its monoidal structure to the abstract adjoint via
  `leftAdjointUniq`" a sound way to obtain `pullbackTensorIso` as a genuine iso, or is there a gap (e.g.
  does `leftAdjointUniq` transport a *monoidal* structure, or only the bare functor iso — and if the latter,
  does the project then still need to check the comparison is monoidal/iso by hand)?
- Is the overall arc (carrier pivot on `IsInvertible` → `IsInvertible.pullback` → re-base RelPic functor →
  A.2.c representability, with the Quot/Cartier engine running in parallel via FlatBaseChange) still the
  right destination ordering for the PRIMARY goal, given the USER ROUTE C (Riemann–Roch) PAUSE?
- Any REJECT/CHALLENGE on the estimations (A.1.c ~6–10 iters; A.2.c-engine ~30–60) or on the negative
  results recorded (locally-free route rejected; oplax-preserves-invertibles false)?

Your prior verdict (ts240) was SOUND with all challenges addressed; this is a re-verification scoped to the
A.1.c Phase 2 route change plus a sanity check that nothing else drifted.
