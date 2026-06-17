# Directive: mathlib-analogist-m3-route-audit-iter123

## Task

**M3 route-pick audit.** Estimate, per route, the cumulative LOC of
upstream Mathlib work that the project would need to contribute (or
backfill via project-local material) in order to formalize
`positiveGenusWitness` for an arbitrary smooth proper geometrically
irreducible curve `C` over a field `k` with `genus C ≥ 1`.

Output two cumulative LOC estimates (Route A vs Route B), one tiebreaker
recommendation, and a verdict on whether the iter-124 plan agent should
trigger user-escalation per STRATEGY.md's hard fallback rule
("if both routes exceed 5000 LOC of estimated upstream-Mathlib work,
escalate to the user for an external-PR routing decision").

## Routes

### Route A — Picard scheme via FGA

The Jacobian is the identity component of the Picard scheme
`Pic_{C/k}` for smooth proper curves. Construction goes through:

1. Hilbert scheme representability for projective schemes
   (`Mathlib.AlgebraicGeometry.Hilbert.Representability` — doesn't
   exist). Sub-decomposition:
   - (a) Hilbert functor `(Sch/k)ᵒᵖ → Set`.
   - (b) Representability theorem via Grothendieck's flattening
     stratification.
   - (c) Smoothness/properness of the Hilbert scheme on smooth
     projective bases.

2. Quot scheme representability — generalises Hilbert; depends on
   coherent-sheaf-of-finite-type infrastructure that is partially in
   Mathlib.

3. Identity-component construction `G^0 ⊆ G` for a `k`-group scheme
   `G` locally of finite type — requires `IsConnectedSpace` for the
   identity component, plus topological connectedness of identity
   components of group objects in `Scheme/k`.

### Route B — Symmetric powers + Stein factorisation

The Jacobian is obtained via the Abel-Jacobi map on `Sym^g(C)`, then
Stein factorisation. Construction:

1. Symmetric powers `Sym^n X` of schemes with smoothness — the
   finite-group-quotient construction `X^n / S_n` with smoothness
   when `X` is smooth (Fogarty's symmetric-product computation).

2. Stein factorisation theorem — for a proper morphism `f : X → Y` of
   locally Noetherian schemes, `f_* O_X` is a coherent `O_Y`-algebra
   and `f` factors as `X → Spec_Y(f_* O_X) → Y`. Requires coherent-
   sheaf cohomology of proper morphisms (partially in Mathlib).

3. Brill-Noether and Riemann-Roch — the curve-side Riemann-Roch
   input is the largest Mathlib gap; absent from Mathlib in usable
   form for the project's genus-via-Ext definition.

## What I want from you

For each route:

1. **For each of the 3 gating pieces**, search Mathlib (latest stable
   or `b80f227`) for what exists. Use `lean_leansearch`, `lean_loogle`,
   and direct file reading. Report:
   - What partial infrastructure exists (named declarations / files).
   - What is missing (the gap proper).
   - An LOC estimate for filling the gap in-project style (i.e. building
     in this project's tree before extracting to Mathlib).

2. **Cumulative LOC estimate per route** (sum of the three gaps).

3. **Cross-utility flag**: For each gap, flag whether it has utility
   outside the Jacobian arc (the Hilbert/Quot infrastructure is broadly
   useful; symmetric-power-of-schemes is more curve-specific). This is
   the STRATEGY.md tiebreaker.

4. **Verdict**:
   - If both routes > 5000 LOC: recommend user-escalation. Optionally
     name the smallest upstream-PR-extractable piece (e.g. if a
     ≤1500-LOC piece could be extracted to a clean Mathlib PR
     independent of the larger project work).
   - If one route ≤ 5000 LOC: recommend that route.
   - If both routes ≤ 5000 LOC: recommend the one with lower LOC, with
     the cross-utility flag as tiebreaker.

5. **Alternative routes**: if you see a third route (e.g. "use the
   classical Albanese variety construction via the étale-local
   linearization of the Abel-Jacobi map", or any other route that
   the strategy doesn't enumerate), flag it.

## Persistent file

Write your full analysis to `analogies/m3-route-audit.md` (it should be
a persistent file usable by future iters' plan agents and any iter-128+
prover lane on M3). Update or create the file as needed.

## Strict context discipline

Do NOT consult STRATEGY.md or `iter/iter-NNN/*.md`. The point of this
audit is a fresh Mathlib-snapshot LOC estimate, not a reverification of
the strategy's framing. The 3-piece-per-route decomposition above is
the only project-side input you need.
