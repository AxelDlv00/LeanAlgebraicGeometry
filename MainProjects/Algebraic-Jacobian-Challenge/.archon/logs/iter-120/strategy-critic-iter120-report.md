# Strategy Critic Report

## Slug

iter120

## Iteration

120

## Routes audited

### Route: End-state with single `nonempty_jacobianWitness` sorry

- **Goal-alignment**: PASS — the nine protected declarations are listed
  verbatim against `references/challenge.lean`; shipping them all closed
  modulo one foundational existence hypothesis matches the challenge's
  stated goal.
- **Mathematical soundness**: PASS — the three classical Albanese routes
  (FGA via `Pic^0` representability through Hilbert/Quot; `Sym^g →
  Pic^g` Stein-factorisation; rigidity for the genus-0 sub-case) are
  the correct trio. The strategy's statement that route C is
  **complementary** to A and B (genus-0 only, and only when
  `C(k) ≠ ∅`) is mathematically correct — over a field with `C` of
  genus 0, `C` is a Brauer–Severi variety, isomorphic to `ℙ¹_k` only
  after `C(k) ≠ ∅`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none — the deferral here is honest; the
  three Mathlib gaps named (Hilbert/Quot, symmetric powers of schemes
  with finite-group-scheme quotients, `Hom(ℙ¹, A) = A(k)` rigidity) are
  genuinely absent from `b80f227`.
- **Effort honesty**: reasonable — explicitly tagged as
  project-external.
- **Verdict**: SOUND.

### Route: Demote `smooth_locally_free_omega` from iff to forward implication

- **Goal-alignment**: PASS — the forward implication is what
  downstream consumers (genus / Jacobian arc) would actually use; the
  iff form is overkill and isn't needed by any protected declaration.
- **Mathematical soundness**: PASS — the converse direction is
  genuinely false without `Subsingleton (Algebra.H1Cotangent A B)` on
  each affine chart. The counterexample `Spec k → Spec k[t], t ↦ 0`
  is correct: it's locally of finite presentation, `Ω = 0` (locally
  free of rank 0), and not flat hence not smooth.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: this isn't an effort claim — it's a correctness
  correction. Honest as a demotion.
- **Verdict**: SOUND.

### Route: Phase C — closure of `smooth_locally_free_omega` via Steps 1–5

- **Goal-alignment**: PARTIAL — the forward implication on the
  *presheaf form* is what the strategy commits to ship, but Step 5's
  framing of the bridge is mathematically wrong.
- **Mathematical soundness**: PARTIAL — Steps 1–4 are sound. **Step 5
  is unsound as written.** STRATEGY.md line 99 calls
  `relativeDifferentialsPresheaf_obj_kaehler` "definitional, body
  `rfl`" and claims this provides the bridge to `Ω[Γ(X,V₀)/Γ(S,U₀)]`.
  It does not. Inspecting `relativeDifferentialsPresheaf` (`Differentials.lean:49–52`)
  and `TopCat.Presheaf.pullback`
  (`.lake/packages/mathlib/Mathlib/Topology/Sheaves/Presheaf.lean:274`,
  defined as `(Opens.map f).op.lan` — presheaf-level inverse image via
  left Kan extension), the `rfl` lemma identifies the section module
  with `Ω[B/A']` where
  `A' = ((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op V₀)
       = colim_{W : f(V₀) ⊆ W} S.presheaf.obj W`,
  which is strictly larger than `A = Γ(S, U₀)`. The iter-119 prover
  finding is correct: Step 5 needs a real proof, not `rfl`.
- **Sunk-cost reasoning detected**: no — but the strategy *did* leave
  the false `rfl` claim in after the iter-119 prover lane returned
  PARTIAL on precisely this point. That's a stale-strategy smell.
- **Phantom prerequisites**: `Mathlib.AlgebraicGeometry.Morphisms.Smooth`'s
  `smoothOfRelativeDimension_iff` (line 134, `@[mk_iff]`): VERIFIED.
  `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`,
  `Algebra.IsStandardSmooth.free_kaehlerDifferential`,
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
  `KaehlerDifferential.map_surjective`: all VERIFIED via local search.
  No phantom prereqs. The issue is purely that one named bridge is
  miscategorised in the strategy.
- **Effort honesty**: under-counted. The "1–3 prover iters / ~100–300
  LOC" assumes the bridge is `rfl`. If the planner takes the
  helper-lemma route (Option 1 below), the bridge alone is plausibly
  another 200–500 LOC of Kähler-Mathlib work, taking the total
  outside the strategy's stated band.
- **Verdict**: CHALLENGE.

## Helper-lemma soundness assessment (Q1 from directive)

The proposed helper lemma
`relativeDifferentialsPresheaf_iso_kaehler_appLE` is
**mathematically true** under the affine hypotheses
`IsAffineOpen U / IsAffineOpen V / V ≤ f⁻¹ U`. Argument sketch:

- `A' = colim_{W : f(V₀) ⊆ W, W ⊆ U₀} O_S(W)` (the subsystem
  `{W ⊆ U₀}` is cofinal because `W ↦ W ∩ U₀` is a refinement when
  `f(V₀) ⊆ U₀`).
- In the affine case, every `W` between `f(V₀)` and `U₀` has its
  sections expressible as localizations of `A = O_S(U₀)`: principal
  opens `D(g) ⊆ U₀` with `D(g) ⊇ f(V₀)` give `O_S(D(g)) = A[1/g]`,
  and `g ∈ A` lands in `B = O_X(V₀)` as a unit because `V₀ ⊆ f⁻¹ D(g)`.
- Hence `image(A' → B)` ⊆ the localization of `image(A → B)` at the
  multiplicative set of "units pulled back from `A`" inside `B`.
- For any `s/t ∈ B` of this form, `d(s/t) = (1/t)·ds + s·d(1/t)`. Since
  `ds = 0` and `d(1/t) = -t⁻²·dt = 0` in `Ω[B/A]`, the differential
  vanishes. So `d(image(A' → B)) ⊆ d(image(A → B)) = 0` in `Ω[B/A]`.
- Therefore the natural surjection `Ω[B/A] → Ω[B/A']` (Mathlib
  `KaehlerDifferential.map_surjective`) has zero kernel and is an
  iso.

So Q1 answer: **TRUE, but provable only via real cofinality plus the
Kähler-vanishes-under-localization argument**. Not `rfl`.

## Recommendation on the three options (Q2/Q3)

**Recommended: Option 3 (statement refactor)**. Restate
`smooth_locally_free_omega` to conclude
`Module.Free Γ(X, V) Ω[Γ(X, V) ⁄ Γ(S, U)] ∧ Module.rank ... = n`
directly, with `IsAffineOpen U / IsAffineOpen V / V ≤ f⁻¹ U` as
hypotheses. The chart data already produced by `mk_iff` matches this
shape; the proof becomes Steps 1–4 of the existing draft.

Reasons:

- `smooth_locally_free_omega` is *not* a protected declaration
  (`archon-protected.yaml` is read-only on the nine `challenge.lean`
  signatures; this is not one of them). The iter-118 refactor already
  changed this same signature (iff → forward implication), so another
  signature refactor on the same non-protected declaration is the
  established precedent, not a new precedent.
- The directive confirms no downstream consumer reads
  `smooth_locally_free_omega`. The project-local
  `relativeDifferentialsPresheaf_obj_kaehler` may remain, just unused
  by this theorem.
- Eliminates the colimit-source issue at the statement level rather
  than papering over it with a hard-to-prove helper.

**Option 1 (helper lemma)**: mathematically tractable but expensive. A
correct proof requires direct manipulation of the `Lan` colimit (no
Mathlib helper that I'm aware of for "cofinality of an affine open in
the inverse-image colimit cone") plus the localization-Kähler
argument. Plausibly 200–500 LOC, possibly 1–2 prover iters of pure
Mathlib lemma-discovery. Acceptable as a fallback if Option 3 is
ruled out for downstream-consumer reasons.

**Option 2 (sheafified inverse-image refactor)**: not recommended. The
directive's claim that the sheafified `f^{-1} O_S` "DOES collapse to
`Γ(S, U)` on affine charts inside affines" is not obviously true. The
sheaf inverse image of `O_S` on `X` has stalks `O_{S,f(x)}` (correct)
but its sections over an affine `V₀ ⊆ X` are *not* generally `Γ(S, U₀)`
for `U₀ ⊇ f(V₀)`; they are the sheafification of the same colimit
presheaf, which on a non-singleton open is a more subtle object.
Refactoring to sheafified inverse image risks trading one bridge
problem for an arguably harder one, and forces re-proof of the
section-level identification (which currently is `rfl` for the
colimit form).

## Alternative routes (suggested)

### Alternative: Drop the presheaf form, work directly in the algebra-Kähler setting

- **What it looks like**: Reframe `smooth_locally_free_omega` as a
  statement purely about affine charts and ring-theoretic Kähler
  modules. The presheaf `relativeDifferentialsPresheaf` is kept (it's
  the right object for sheafification down the line), but the
  "Jacobian criterion" theorem doesn't go through it. The blueprint
  chapter `Differentials.tex` adds a one-line note that the section
  module of `relativeDifferentialsPresheaf` is `Ω[B/A']` for the
  colimit source, equivalent to `Ω[B/A]` on affine charts (with a
  pointer to a future helper lemma left as "Mathlib-side, deferred").
- **Why it might be cheaper or sounder**: this is Option 3 reframed —
  it isolates the "presheaf bridge" as a project-external Mathlib
  question rather than a Phase-C blocker.
- **What the current strategy may have rejected**: unclear, planner
  should clarify. The strategy commits to the *presheaf form* of the
  forward implication, but the rationale for "must be presheaf form,
  not algebra-Kähler form" is not stated.
- **Severity of the omission**: major. The strategy locks in a form
  for the theorem that is genuinely harder to prove with no stated
  downstream reason.

### Alternative: Add the bridge as a public Mathlib gap rather than an inline obligation

- **What it looks like**: The bridge
  `relativeDifferentialsPresheaf_iso_kaehler_appLE` is added to the
  "Mathlib gaps left for whoever picks up the project" section
  alongside the converse-direction gap. Phase C ships with two
  inline `sorry`s (the witness + the bridge), with the bridge marked
  as ring-theoretic / Mathlib-bound rather than scheme-theoretic.
- **Why it might be cheaper or sounder**: cheap because the iter band
  stays at 1–3; sound because the rest of `smooth_locally_free_omega`
  is genuinely close. Honest because the bridge is the kind of
  Mathlib-bound work the project is already disclosing.
- **What the current strategy may have rejected**: the "exactly one
  inline sorry" end-state is rhetorically clean, but it isn't
  load-bearing on the challenge — `challenge.lean` doesn't enforce
  any sorry count, only signatures.
- **Severity of the omission**: minor (this is a presentation tweak,
  not a route).

## Sunk-cost flags

- `relativeDifferentialsPresheaf_obj_kaehler\n    (definitional, body `rfl`)` (STRATEGY.md line 99) — Why this is
  sunk-cost: the strategy retained the `rfl` claim through iter-120
  even though the iter-119 prover lane returned PARTIAL specifically
  because the `rfl` does *not* land at `Ω[Γ(X,V)⁄Γ(S,U)]`.
  Recommendation: rewrite Step 5 in STRATEGY.md to reflect that
  `relativeDifferentialsPresheaf_obj_kaehler` lands at the
  colimit-source Kähler module, and either (a) commit to Option 3
  (statement refactor, no bridge needed), or (b) commit to Option 1
  (real bridge lemma) with an honest expanded cost estimate.

## Prerequisite verification

- `AlgebraicGeometry.smoothOfRelativeDimension_iff`: VERIFIED
  (auto-generated by `@[mk_iff]` at
  `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:134`).
- `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`:
  VERIFIED (used directly at `Differentials.lean:104`).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED
  (Mathlib instance, found via local search at
  `RingTheory/Smooth/StandardSmoothCotangent.lean`).
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`:
  VERIFIED (same file).
- `KaehlerDifferential.map_surjective`: VERIFIED
  (`Mathlib/RingTheory/Kaehler/Basic.lean`).
- `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`:
  VERIFIED as a `rfl` declaration (project-local,
  `Differentials.lean:58`). BUT: its target type is **not** what the
  strategy claims — it's `Ω` over the colimit source, not over
  `Γ(S, U)`. Strategy mischaracterisation, not phantom prerequisite.

## Must-fix-this-iter

- Route Phase C: CHALLENGE — the strategy claims the bridge
  `relativeDifferentialsPresheaf_obj_kaehler` is `rfl` from the
  presheaf section module to `Ω[Γ(X,V₀)⁄Γ(S,U₀)]`. It is not; the
  `rfl` lands at `Ω[Γ(X,V₀)⁄A']` with `A' =
  colim_{W ⊇ f(V₀)} O_S(W)`. The planner must either (a) rewrite the
  Phase C "Closing-lemma slate" so Step 5 names a real bridge lemma
  and expand the cost estimate honestly, OR (b) refactor the
  signature of `smooth_locally_free_omega` to conclude over
  `Ω[Γ(X,V)⁄Γ(S,U)]` directly (Option 3 in the directive). Option 3
  is recommended because the declaration is non-protected and has no
  downstream consumers in the live project.
- Alternative "Drop presheaf form": major — the strategy commits to
  the presheaf-section form of the conclusion without a downstream
  justification, locking in a genuinely harder proof. Planner must
  either name the downstream consumer or move to the algebra-Kähler
  form.

## Overall verdict

A fresh mathematician would approve the overall end-state framing
(one named existence hypothesis, three classical Albanese routes
disclosed, signatures verified against `challenge.lean`), but would
**reject Phase C as currently described** because Step 5's "`rfl`
bridge" claim is false in a way that's diagnostically obvious from
the definition of `relativeDifferentialsPresheaf` and the
left-Kan-extension form of `TopCat.Presheaf.pullback`. The cheapest
fix is a non-protected signature refactor of
`smooth_locally_free_omega` to conclude directly over the
algebra-Kähler module `Ω[Γ(X,V)⁄Γ(S,U)]`; this preserves the project's
end-state in spirit (forward direction of the Jacobian criterion,
shipping unconditionally) while eliminating the colimit-source bridge.
The strategy is otherwise sound — the rest of the path to end-state
holds up.
