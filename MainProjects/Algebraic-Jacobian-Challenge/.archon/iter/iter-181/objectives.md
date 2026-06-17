# Iter-181 prover objectives (detailed)

## Critic-disclosure 3-tier vocabulary (applies to all lanes)

Every closed lemma in your task_result MUST classify the body as one of:

1. **kernel-clean (this body)** — `#print axioms <lemma>` returns
   `{propext, Classical.choice, Quot.sound}` (the kernel baseline only).
2. **kernel-clean modulo upstream `<X>` / `<Y>`** — local body has no
   `sorry`, but `#print axioms <lemma>` returns `…, sorryAx, …` because
   the transitive dependency `<X>` or `<Y>` is sorry-bodied. List the
   named upstream sorry carriers explicitly.
3. **kernel-clean (transitively)** — `#print axioms <lemma>` returns
   the kernel baseline AND every transitive dependency is sorry-free.

NEVER report a body as "axiom-clean" without checking `#print axioms`
on it. The iter-180 lean-auditor MAJOR was triggered by exactly this
laxity (Lane E claimed "axiom-clean" but inherited `sorryAx` via
upstream RR.2). Use the 3-tier vocabulary so the reviewer can read the
status from the task_result without re-running `lean_verify` itself.

---

## Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`

**Target**: Close the body of `Scheme.lineBundleAtClosedPoint.globalSections_iff`
(line ~192 post plan-phase refactor; signature `∃ s, lineBundleAtClosedPoint.toFunctionField P hP s = f`).

**Background**: The plan-phase `refactor ocofp-globalsections-sig`
mutated the signature so the iff binds the global section `s` to the
rational function `f`. This Lane A fills the body. Both directions are
documented inside the existing `globalSections_iff` body (forward =
Hartshorne II.7.7(b); backward = II.7.7(a)).

**Two sub-cases (both directions)**:

- **Forward (II.7.7(b))**: given the order conditions on `f`, construct
  `s ∈ H⁰(C, 𝒪_C(P))` with `toFunctionField P hP s = f`. Concretely:
  the rational function `f` (with at most a simple pole at `P` and
  holomorphic at every other prime divisor) lifts to a Cartier section
  of the locally-free sheaf `𝒪_C(P)`; `s` is the global section it
  defines (Hartshorne II.7.7(b)'s construction).
- **Backward (II.7.7(a))**: given `s ∈ H⁰(C, 𝒪_C(P))` with
  `toFunctionField P hP s = f`, read off the order conditions
  stalk-by-stalk via the DVR identification
  `𝒪_C(P)_Q = 𝒪_{C,Q}` for `Q ≠ P` and
  `𝒪_C(P)_P = f_P⁻¹ · 𝒪_{C,P}`.

**Blocker**: BOTH directions consume the body of `lineBundleAtClosedPoint`
(L140), which is still a typed `sorry`. If you cannot fire either
direction without that body, your lane is correctly PARTIAL — leave the
forward + backward sub-cases as named honest sorries (one per direction,
with detailed comments citing the missing infrastructure piece) and
move on. Do NOT introduce a placeholder body for `lineBundleAtClosedPoint`
itself — that path was already analysed iter-180 (Lane D task_result) as
blocked on Sheaf-internal-Hom + ModuleCat-forget Mathlib gaps.

**Helper budget**: 2 (one per direction if needed; both must be honest
substantive helpers with `#print axioms` reports).

**Blueprint**: `chapters/RiemannRoch_OCofP.tex` (just tightened
plan-phase to bind `s` to `f` explicitly). Read
`lem:lineBundleAtClosedPoint_globalSections_iff` block + its proof
block; Hartshorne pp.~156–158 quoted verbatim.

**Verification**: BEFORE starting, verify the file compiles GREEN with
the new signature shape (i.e. the plan-phase refactor landed). If the
refactor did NOT land (e.g. signature is still vacuous-in-`f`), STOP
and report PARTIAL with "blocked on plan-phase refactor".

---

## Lane B — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

**Target**: Close the CROSS case of `gmScalingP1_chart_agreement`
(L289 — single sorry inside the lemma body, currently the only sub-case
not handled by the diagonal `fst_eq_snd_of_mono_eq` route).

**Concrete content**: The cross case `(x, y) = (0, 1)` or `(1, 0)` in
`Fin 2 × Fin 2` reduces to the ring identity
`λ · u = (1/t) · λ` in `Localization.Away t ⊗[kbar] GmRing`. Per the
iter-180 Lane A task_result: this is a cocycle-bridge algebra chase
analogous to `gmScalingP1_chart_PLB_eq`'s multi-stage unfold, but the
`set_option backward.isDefEq.respectTransparency false` recipe is NOT
applicable here (different family of blockers — the `Algebra.compHom`
chain is not the heartbeat sink in this case).

**Strategy**: chase the chart identification via
`gmScalingP1_chart_PLB_eq` (now axiom-clean, L213) + the
`gmScalingP1_chart1_ringMap` definition (`u ↦ u ⊗ λ`) and analogous
chart-0 ring map. Combine with
`pullbackRightPullbackFstIso_hom_fst_assoc` +
`pullbackSymmetry_hom_comp_fst_assoc` to land the ring identity at
the goal level.

**Helper budget**: 1 (a single named cocycle-helper lemma for the
ring identity, if needed).

**Off-target this lane**: `gmScalingP1_collapse_at_zero` (L353) — leave
as honest sorry; it uses `Cover.hom_ext` against `pointOfVec` (different
strategy). iter-182 prover lane target.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated via
`% archon:covers`). The chart-bridge section already documents the
σ_× and cross-case agreement.

**Verification**: `#print axioms` on the closed cross-case body
should return either kernel-clean (this body) or kernel-clean modulo
upstream `gmScalingP1_chart_PLB_eq`-helpers.

---

## Lane C — `AlgebraicJacobian/Genus0BaseObjects/Points.lean`

**Target**: Close `gmHomEquiv_left_inv` (L395) AND `gmHomEquiv_right_inv`
(L419) — the 2 named round-trip identities iter-180 Lane B isolated for
the `Equiv` building `gm_grpObj` via `GrpObj.ofRepresentableBy`.

**Concrete strategy** (per iter-180 Lane B task_result "Concrete next
steps for iter-181"):

- **`gmHomEquiv_right_inv` (`toFun (invFun u) = u`)**: try
  `Subsingleton.elim` on the `IsUnit` proofs (`hgu` vs `⋯`) to bring
  them into definitional alignment, then the `have hsimplify` approach
  with explicit morphism equality fires. Alternative: use `convert`
  with `IsLocalization.Away.lift_eq` + the chain
  `Scheme.Hom.comp_appTop → ΓSpecIso_inv_naturality_assoc →
  toSpecΓ_appTop → Iso.inv_hom_id ∘ Category.comp_id →
  IsLocalization.Away.lift_eq → MvPolynomial.eval₂Hom_X'`.
- **`gmHomEquiv_left_inv` (`invFun (toFun f) = f`)**: invoke
  `AlgebraicGeometry.ext_to_Spec` after `Over.OverMorphism.ext`, then
  prove ring map equality via `ext` + `MvPolynomial.ringHom_ext` on
  the polynomial-ring side. The two equalities to prove on the
  generators of the source ring `k̄[t,t⁻¹]`: (a) on the structural
  map `algebraMap k̄ GmRing` (forced by `Over.w` of `f`); (b) on the
  generator `X()` (the unit's value, by definition of `toFun`).

**Helper budget**: 2 (one per round-trip identity if needed). The 5
iter-180 axiom-clean helpers should NOT be re-touched — they are
correct as landed.

**Off-target this lane**: `gm_grpObj` itself is structurally complete
modulo these 2 round-trips; do NOT mutate its definition.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated;
`% archon:covers` includes `Points.lean`).

**Verification**: post-closure, `#print axioms gm_grpObj` should drop
from `{propext, sorryAx, Classical.choice, Quot.sound}` to
`{propext, Classical.choice, Quot.sound}` — kernel-clean (this body)
+ kernel-clean (transitively) since all 5 iter-180 helpers were
already kernel-clean.

---

## Lane D — `AlgebraicJacobian/Picard/RelativeSpec.lean`

**Target**: Close the body of `pullback_iso` (L429 — single remaining
sorry after iter-180 Lane C closed `coequifibered`).

**Strategy** (per iter-180 Lane C task_result "Suggested next step"):
assemble the cocone over the directed affine cover of `T` and invoke
the colimit universal property of `Cover.RelativeGluingData.glued`.
Each affine open `U ⊆ T` has preimage `q⁻¹U` affine (via the
now-proven `pullback_fst_isAffineHom`); each affine piece is
Mathlib-isomorphic to `Spec((g^*𝒜).sheaf(U))` by construction of
`QcohAlgebra.pullback.sheaf` as the pushforward.

Helper to build: `pullback_iso_affine_piece` (per-affine-open iso
component), then the global iso via colimit-universal-property of
`AffineZariskiSite.relativeGluingData`.

**Helper budget**: 2 (per-affine iso + colimit-glue).

**Blueprint**: `chapters/Picard_RelativeSpec.tex`. Helpers
`pullback_fst_isAffineHom` and `pullback_coequifibered` are unblueprinted
auxiliary lemmas (per iter-180 Lane C task_result); the new
`pullback_iso` body helpers can stay unblueprinted as well.

**Verification**: `#print axioms QcohAlgebra.pullback_iso` should
return kernel-clean (transitively) if both helpers close
kernel-clean (transitively); otherwise kernel-clean modulo upstream
`<helper>`.

---

## Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

**Target**: Close `iotaGm_isDominant` body (L86) using the iter-180
Lane A's PRIMARY closure of `gmScalingP1_chart_PLB_eq` + iter-180
Lane B's substrate (`gm_grpObj` partially built).

**Background**: iter-178 Lane 2 hit the analogist-recipe DEAD END
(`IsOpenImmersion.isDominant _` not in Mathlib). The iter-179 Lane B's
structural reduction to `DenseRange` is the iter-181 pickup. Key facts
now available iter-181 that weren't iter-178:
- `gmScalingP1_chart_PLB_eq` is axiom-clean (iter-180), so the
  `iotaGm` definition's load-bearing iso is now closed.
- `gmScalingP1_cover` is uniform-in-`i` (iter-179 refactor); cover-side
  reasoning is unblocked.

**Strategy**: `iotaGm.left` is the projection
`pullback PLB.hom Gm.hom ⟶ PLB`. Show it's dominant via image-density:
the image contains the dense open `D₊(X 0 · X 1)` (the chart-1 + chart-2
overlap) by the chart-bridge cover. Apply
`AlgebraicGeometry.IsDominant.of_isOpenImmersion`-style chains on the
overlap, plus `IsDominant.of_comp_iff`.

Search for: `IsDominant.of_isOpen…`, `IsDominant.image_dense`,
`Scheme.Hom.dense_range_iff`. (Use `lean_local_search` first to confirm
which Mathlib idiom exists; the analogist-noted dead-end was for
`IsOpenImmersion.isDominant`, but adjacent dominance lemmas may apply.)

**Helper budget**: 2.

**Acceptable fallback**: if the substantive dominance argument cannot
land in budget, factor the missing piece into a single named helper
sorry and report PARTIAL with explicit Mathlib gap.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (covers AVR).

---

## Lane F — `AlgebraicJacobian/Picard/QuotScheme.lean`

**Target**: Close the body of `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen`
(iter-180 Lane F helper #1, located at L446 post iter-180).

**Strategy** (per iter-180 Lane F task_result "What's substantive in
each helper" + "Lemmas / instances found relevant"):

The affine-open case asserts the iso property on `Module.Flat.isBaseChange`.
Three sub-bridges:
1. Affine-open identification of `(pullback g).obj ((pushforward f).obj F)`
   sections with tensor products
   `Γ(S', U) ⊗_{Γ(S, V)} Γ(f⁻¹V, F)`.
2. Affine-open identification of `(pushforward f').obj ((pullback g').obj F)`
   sections with `Γ((f')⁻¹U, (g')*F)`.
3. The `Module.Flat.isBaseChange` invocation (Mathlib
   `Mathlib.RingTheory.Flat.Stability` — confirmed IN SCOPE iter-180).

Sub-bridges 1 + 2 are Mathlib-gap-shaped; if neither lands in iter-181
budget, factor each into a single named helper sorry — these are
substantive Mathlib gaps named already in iter-180 Lane F task_result.

**Helper budget**: 2.

**Off-target**: helper #2 (`_of_affineCover`) — leave for iter-182.

**Blueprint**: `chapters/Picard_QuotScheme.tex`
`thm:flat_base_change_cohomology` (Stacks 02KH(ii)).

---

## Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

**Target**: Start one of the 4 depth-dependent lemmas (per iter-180
Lane H "Concrete next steps"). Prover picks smallest:
- `depth_eq_smallest_ext_index` (L228, Stacks 00LP) — induction on
  `n` via long exact `Ext^*(κ, -)` on `0 → M → M → M/xM → 0`.
- `depth_of_short_exact` (L268, Stacks 00LE) — requires
  `depth_eq_smallest_ext_index` first; then 3 inequalities direct
  from long exact `Ext^*`.
- `auslander_buchsbaum_formula` (L326, Stacks 090V) — requires
  the above two (likely longest body).
- `CohenMacaulay.of_regular` (L396, Stacks 00OD) — direct regular-sequence
  argument; alternative via AB formula. Smallest direct-route option.

**Strategy**: per iter-180 Lane H task_result, decompose
`depth_eq_smallest_ext_index` into 2 narrower lemmas
(`depth_zero_iff_exists_assoc_prime` + `depth_succ_iff_exists_nzd_with_pred`)
plus a `Nat.rec` combine. Alternatively, attempt `CohenMacaulay.of_regular`
via the direct Stacks 00OD route (~50–80 LOC).

**Helper budget**: 2.

**Off-target**: the remaining 3 depth-dependent lemmas — close one,
defer the rest to iter-182.

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex`.

---

## Lane H — `AlgebraicJacobian/RiemannRoch/RRFormula.lean`

**Target**: Close `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`
body (L224). This is the **upstream sorry** that the auditor MAJOR on
Lane E iter-180 flagged — closing it retires the transitively-inherited
`sorryAx` on `l_eq_degree_plus_one_of_genus_zero`.

**Strategy** (per iter-180 Lane E task_result "Concrete next steps
(iter-181+)"):
- **Base case `D = 0`**: `𝒪_C(0) = 𝒪_C`, then `χ(𝒪_C) = (1 : ℤ) − (genus C : ℤ)`
  from `dim H⁰(𝒪_C) = 1` (Hartshorne I.3.4) and the definition of
  genus.
- **Inductive step `D ↦ D + [P]`**: project-side short-exact-sequence
  additivity of χ on `0 → 𝒪_C(D) → 𝒪_C(D + [P]) → k(P) → 0`, with
  `χ(k(P)) = 1` (skyscraper).
- **Generic case**: `Div(C)` is a free abelian group on closed points;
  induct on the signed-generator count.

**Mathlib gap candidates** (per blueprint note): no
`CategoryTheory.ShortExact.eulerChar_additive` under that name; the
additivity needs to be threaded from
`Submodule.finrank_quotient_add_finrank` + the long exact sequence of
`H^*`.

**Acceptable fallback**: if the SES additivity gap is too large to
fill in budget, factor it into a single named `chi_additive_of_ses`
helper and report PARTIAL with explicit Mathlib gap.

**Helper budget**: 2.

**Off-target**: `sheafOf` (L168) — type-level placeholder; waits on
RR.3 sibling file work.

**Blueprint**: `chapters/RiemannRoch_RRFormula.tex`.

---

## Lane I — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

**Target**: SIGNATURE REFINEMENT on `iso_of_degree_one` (Pin 3). Per the
plan-phase mathlib-analogist consult `ratcurveiso-pins` (PROCEED with
DIVERGE_INTENTIONALLY on Pin 3.2):

Refine the hypothesis from "abstract function-field iso" to "function-field
map induced by `φ` is iso" — equivalently, parameterise on
`Module.finrank C'.functionField C.functionField = 1` (i.e. `φ`'s
function-field pullback is iso). The current existence-hypothesis is a
file-skeleton placeholder that is strictly weaker than what the
birational-extension argument needs (per analogist report Step 1).

**Concrete signature change** (analogist report):
```lean
-- BEFORE (file-skeleton placeholder):
lemma iso_of_degree_one (φ : ...) (h : (some-existence-hypothesis)) : IsIso φ := …

-- AFTER (this lane):
lemma iso_of_degree_one (φ : ...)
    (h : Module.finrank C'.functionField C.functionField = 1) :
    IsIso φ := …
-- OR equivalently using the "induced by φ" predicate:
lemma iso_of_degree_one (φ : ...)
    (h : Function.Bijective (φ.functionFieldHom)) :
    IsIso φ := …
```

The lane scope is the signature mutation + new typed `sorry` body;
the body lands iter-182+ via the 3-step strategy in the analogist
recipe. Verify by `lake env lean` that the file still compiles GREEN
after the mutation.

**Helper budget**: 0 (signature work; no body).

**Off-target**: Pin 2 (`morphism_degree_via_pole_divisor`) — its
signature is fine as-is per the analogist; iter-182 prover lane will
attack its body via `Ideal.sum_ramification_inertia`.

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex`. After this
lane lands, the chapter prose for `iso_of_degree_one` should be
re-tightened to match the new signature; the planner will handle that
in iter-182's plan-phase per the iter-180 critic's "signature-drift
watchlist" guidance.

**Verification**: file compiles GREEN; `iso_of_degree_one`'s body is a
single `sorry` with docstring updated to cite
`analogies/ratcurveiso-pin3.md` Steps 1–4 strategy.

---

## Dispatch order suggestion

If the harness runs lanes in parallel, they're independent (different
files). If sequenced, suggested order: D (small, axiom-clean target) →
G (single-lemma close on AB) → I (signature-only) → H (upstream sorry
close) → A (post-refactor) → C (round-trip identities) → B (cocycle
algebra) → F (Mathlib-Flat invocation) → E (dominance reasoning).
