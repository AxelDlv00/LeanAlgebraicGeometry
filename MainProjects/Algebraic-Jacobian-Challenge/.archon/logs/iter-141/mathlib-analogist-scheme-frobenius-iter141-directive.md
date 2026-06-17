# Mathlib analogist directive — scheme-Frobenius scoping (iter-141)

## Standing scope and purpose

The project is committed (per STRATEGY.md § "M2.body-pile" piece (iii) +
the iter-140 STRATEGY.md Edit 4 "iter-141+ scheduled obligations") to
firing this analogist consult at iter-141 with the following pivot criterion:

> If revised LOC estimate exceeds 2000 LOC, elevate the named-gap-sorry
> alternative from "active alternative" to "preferred default" with
> explicit STRATEGY.md revision.

Your task is to scope `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM
against Mathlib `b80f227` (the project's current `lean-toolchain` /
mathlib snapshot), using Stacks Tag 0CC4 as the canonical construction
reference and `Mathlib.Algebra.CharP.Frobenius` as the ring-side baseline.

Output: a per-sub-piece LOC estimate, idiom-alignment cost broken out
explicitly (parallel-API risk; consumer-side bridge-lemma cost),
prerequisite gaps, and a verdict on whether the in-tree build is
sustainable at < 2000 LOC.

## Project context (one paragraph)

Piece (iii) of the M2.body-pile is "char-`p` Frobenius iteration": the
char-`p` argument that, in characteristic `p`, when `df = 0` for a
morphism `f : C → A` of smooth proper schemes, `f` need not factor
through Spec k, but `f` factors through the absolute Frobenius `F_X`. The
project needs the **scheme-level absolute Frobenius `F_X` (intrinsic
to X, base-independent)** — NOT relative Frobenius `F_{X/k}` (which
over non-perfect `k` requires `[PerfectField]`).

Mathlib `b80f227` has:
- **Ring-side**: `Mathlib.Algebra.CharP.Frobenius` — yes. Defines
  `frobenius R p : R →+* R` for `[CharP R p]`, with `iterateFrobenius R p n`.
- **Scheme-side absolute Frobenius**: **NO** (PHANTOM per
  `strategy-critic-iter128`; `lean_local_search "Frobenius"` returns
  only the ring-side file + `NumberTheory.FrobeniusNumber` (unrelated)).

The project must build the scheme-level construction from the ring-side
baseline.

## Inputs you may read

- `references/challenge.lean` (just to confirm the signature shape of
  `nonempty_jacobianWitness`; the scheme-Frobenius is downstream of M2.a body).
- `references/summary.md` (one paragraph).
- The Mathlib snapshot at `b80f227` (the project's current toolchain;
  use `lean_local_search`, `lean_leansearch`, `lean_loogle`, `lean_hover_info`
  to scope what exists).
- Stacks Tag 0CC4 (lookup via `WebFetch` if available, or your training-
  data baseline).
- `analogies/direct-chart-algebra-rigidity-ib-ic.md` (iter-140 chart-
  algebra-rigidity alternative; cross-reference to confirm whether the
  scheme-Frobenius PHANTOM build can be by-passed entirely by routing
  piece (iii) through chart-level `iterateFrobenius` on ring-level
  charts).
- `STRATEGY.md` § "Mathlib gap inventory" piece (iii) row (lines ~471+).

You may NOT read any iter sidecar, `PROGRESS.md`, `task_pending.md`,
or `task_done.md`.

## Sub-pieces to scope (each with LOC estimate and gap analysis)

1. **`AlgebraicGeometry.Scheme.absoluteFrobenius` definition** —
   the absolute Frobenius `F_X : X → X` for any scheme `X` in
   characteristic `p`. Per Stacks Tag 0CC4: on a single affine
   `Spec R`, this is `Spec (frobenius R p)`. Globalisation requires
   coherence across affine opens (i.e., `frobenius` is natural in
   the ring).
   - What Mathlib infrastructure exists to support this construction
     (Sheaf functoriality on affine schemes; `Scheme.Spec` natural in
     ring maps; etc.)?
   - LOC estimate for the definition + functoriality + basic API.

2. **Compatibility with affine-open immersions / restriction**:
   `F_X |_U = F_U` for any open `U ⊆ X`. Required for chart-level
   reasoning.
   - LOC estimate.

3. **Frobenius iteration `iterateFrobenius_X p n : X → X`** —
   `n`-fold iterate. Mathlib has `iterateFrobenius R p n` on the ring
   side; the scheme-side iterate should follow definitionally from
   the definition + iteration of `Spec`.
   - LOC estimate.

4. **Key consumer lemma "df = 0 and `f : C → A` over a char-p field
   ⇒ `f` factors through some iterate of `F_C`"** — this is the
   actual *use* of piece (iii) in the M2.a body. The scheme-level
   absolute Frobenius is in service of this consumer lemma.
   - LOC estimate for the consumer lemma after the prerequisites are
     in place.
   - Is the prose / formal statement of this lemma already in
     Mathlib in any form (e.g., as part of the structure-theory of
     smooth-morphisms-over-char-p)?

5. **Parallel-API risk on `Scheme.Spec` functoriality**: when the
   project lifts ring-side `frobenius` to scheme-side, does it create
   a copy of `Scheme.Spec`-functoriality material that already exists
   in Mathlib? E.g., does
   `Scheme.specObj_specMap_frobenius : Scheme.Spec.map (CommRingCat.ofHom (frobenius R p)) ≫ _ = _`
   collide with any existing Mathlib `Scheme.Spec.map` lemma family?

6. **Alternative route via chart-algebra rigidity**: per the iter-140
   `mathlib-analogist-chart-algebra-rigidity-iter140` HYBRID verdict
   (`analogies/direct-chart-algebra-rigidity-ib-ic.md`), there is an
   alternative that **routes piece (iii) entirely through ring-level
   chart algebras and `iterateFrobenius` on charts**, by-passing the
   scheme-level `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM
   build. Cross-reference this. Is the chart-algebra alternative a
   genuine replacement for the scheme-Frobenius PHANTOM build, or does
   it only replace the M2.a body's `df=0 ⇒ factors-through-F_C` consumer
   lemma while leaving the scheme-Frobenius PHANTOM as load-bearing for
   *other* downstream consumers (Mathlib-PR utility, future M4, etc.)?

## Pivot criterion (verbatim from STRATEGY.md)

If your revised total LOC estimate (sub-pieces 1–4, optionally 5)
**exceeds 2000 LOC**, your verdict ELEVATES the named-gap-sorry
alternative on piece (iii) from "active alternative" to "preferred
default", and the planner is OBLIGATED to revise STRATEGY.md
accordingly.

If your verdict is < 2000 LOC, the in-tree scheme-Frobenius build is
sustainable, and the planner proceeds per the existing piece (iii)
iter-144+ commitment.

If the alternative chart-algebra route (sub-piece 6) genuinely
by-passes the scheme-Frobenius PHANTOM build for the M2.a consumer,
note this as a separate HYBRID verdict and surface the LOC delta.

## Persistent output

Write your full report to `task_results/mathlib-analogist-scheme-frobenius-iter141.md`
(the dispatcher wrapper handles the path). Also write your persistent
analogy file to `analogies/scheme-frobenius-piece-iii-scoping.md`. The
analogy file is the input for the iter-144 mandatory chart-algebra-vs-
bundled re-evaluation gate (per STRATEGY.md Edit 4 "iter-144 mandatory").
