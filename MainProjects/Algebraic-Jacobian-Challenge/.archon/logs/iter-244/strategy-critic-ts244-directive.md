# Strategy Critic Directive

## Slug
ts244

## What to read (and ONLY this)
- `.archon/STRATEGY.md` (verbatim — just updated this iter).
- `references/summary.md` (the reference index).
- Blueprint chapter titles + one-line topics: derive by listing
  `blueprint/src/chapters/*.tex` and reading each chapter's first
  `\section{...}` / leading comment. Do NOT read chapter proof bodies in depth.

Do NOT read iter sidecars, task_*.md, prover reports, or any per-iter narrative.
Your value is a fresh mathematician's read of the strategy as written.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` + `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian
object uniform over the `k`-rational pointing of a smooth proper geometrically irreducible
curve `C/k` (`[Field k]` only). `J := Pic⁰_{C/k}` built unconditionally; only `isAlbaneseFor`
is quantified over the pointing. End-state: zero inline `sorry` in each protected decl's cone,
0 project axioms. The near-term PRIMARY GOAL (user directive) is a complete proof of
`Pic_{C/k}` representability (A.2.c), bottom-up. Riemann–Roch (Route C) is PAUSED by user.

## The specific strategic decisions to validate this iter

This iter made a route pivot on the A.1.c critical-path substrate `IsInvertible.pullback`
(pullback preserves ⊗-invertibility), encoded in STRATEGY.md (phase rows A.1.c.sub / A.1.c.fun,
and the A.1.c route paragraph under `## Routes`). Validate these decisions specifically:

1. **The "commit to the build" pivot.** A Mathlib-idiom analyst established (twice, iters 242 &
   244) that `IsInvertible.pullback` is Mathlib-scale via EVERY route: both the "pullback is
   strong monoidal (δ iso)" route and the "invertible ⇒ locally trivial forward-bridge" route are
   multi-hundred-LOC and bottom out at the same root gap — Mathlib has no concrete
   inverse-image-of-presheaves-of-modules model (`PresheafOfModules.pullback` is an abstract left
   adjoint, only oplax). The strategy now COMMITS to building the concrete strong-monoidal
   inverse-image pullback (`pullback φ ≅ extendScalars φ ⋙ pullback₀`, extendScalars strong free,
   `pullback₀ = Lan (Opens.map f.base).op` the genuine build, transport via `leftAdjointUniq`),
   rather than seeking a 6th cheap surface route. **Is committing to this build the right call,
   or is there a genuinely different strategic route to A.1.c / A.2.c that avoids strong
   monoidality of pullback altogether?** (e.g. is there a way to define the relative Picard
   functor's structure maps that does NOT require pullback-preserves-invertibility as a lemma?)

2. **The parallelization via a typed-sorry bridge.** To keep the PRIMARY GOAL (A.2.c) moving
   while the multi-hundred-LOC substrate builds, the plan pins `IsInvertible.pullback` as a
   documented typed-sorry bridge and authors the downstream RPF functor (A.1.c.fun) against it in
   parallel (Mathlib-gradient: the substrate build is the explicit objective discharging the
   sorry). **Is this sound, or does it risk authoring RPF on a substrate whose final shape might
   force a re-author?** Is there a sequencing hazard?

3. **The re-estimate.** A.1.c.sub is now ~10–18 iters / ~500–900 LOC (was ~7–11). Is the
   total Route-A arc still coherent given the substrate is bigger than previously framed?

4. **Rotation-churn root-gap question (raised by the progress-critic).** The last 5 iters found
   successive surface routes (concrete-P → local-trivialization → δ-iso) that each bottomed at
   the same absent infrastructure. Confirm whether these genuinely share one root gap (the
   concrete inverse-image model), and whether "build it" is the correct response vs. a deeper
   pivot (e.g. accept the substrate as a permanent sorry-axiom and proceed, or restructure the
   carrier).

## Output
Per the descriptor: SOUND / CHALLENGE / REJECT with explicit reasoning. If you CHALLENGE the
build-commitment or the parallelization, name the concrete alternative. Cite references where a
construction's feasibility or a route's necessity is at stake (read the local source files).
