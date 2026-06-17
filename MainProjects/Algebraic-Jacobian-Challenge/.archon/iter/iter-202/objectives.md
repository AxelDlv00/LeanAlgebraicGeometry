# Iter-202 — Per-lane objectives

This sidecar contains the per-lane prover directives in full, mirrored
to `PROGRESS.md`'s `## Current Objectives` section in condensed form.

## Lane WD-A4a-Sub-build-3 (`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`)

**Mode**: `mathlib-build`. Helper budget = 2. Priority-1 (A.4.a root).

**Goal**: discharge the `h_compat` hypothesis of the iter-201
parameterised packaging
`Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` by specialising
`e_K` to `Scheme.Opens.functionFieldIso U` and proving the
function-field-side compatibility from naturality of
`stalkSpecializes` along `Scheme.Opens.stalkIso`.

**Reference**: Stacks 02IZ (stalk under open immersion) + Mathlib's
`PresheafedSpace.stalkMap.stalkSpecializes_stalkMap_assoc`
(`Mathlib/Geometry/RingedSpace/Stalks.lean`) +
iter-201 task report Sub-build 3 handoff at
`task_results/archive/iter-201/AlgebraicJacobian_RiemannRoch_WeilDivisor.lean.md`
lines 140--189. Reference also `Mathlib.AlgebraicGeometry.FunctionField`
L81-95 (algebraMap definition) and `Mathlib.AlgebraicGeometry.Restrict`
(`Scheme.Opens.stalkIso` definition + `germ_stalkIso_hom_assoc`).

**Recipe** (~30-60 LOC, per iter-201 prover scout):

(1) Build a project-local lemma
```
lemma Scheme.PrimeDivisor.functionFieldIso_compat
    {X : Scheme.{u}} [IsIntegral X]
    (U : X.Opens) [Nonempty U] [IsIntegral U.toScheme]
    (Y : X.PrimeDivisor) (hYU : Y.point ∈ U)
    (r : U.toScheme.presheaf.stalk
            (Scheme.PrimeDivisor.restrictToOpen U Y hYU).point) :
    (Scheme.Opens.functionFieldIso U).hom.hom
      (algebraMap _ U.toScheme.functionField r) =
    algebraMap _ X.functionField
      ((Scheme.PrimeDivisor.stalkIso U Y hYU).commRingCatIsoToRingEquiv r)
```
Proof: the morphism-level commutativity
`stalkIso ≫ stalkSpecializes (X-side gp ⤳ Y)
 = stalkSpecializes (U-side gp ⤳ Y') ≫ functionFieldIso`
in `CommRingCat` (via `germ_stalkIso_hom_assoc` or
`stalkSpecializes_stalkMap_assoc`), applied pointwise.

(2) **PUSH-BEYOND step**: specialize
`Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` to the canonical
`e_K = (Scheme.Opens.functionFieldIso U).commRingCatIsoToRingEquiv`
and discharge `h_compat` via the lemma from (1). This produces the
Sub-build 3 endpoint:
```
lemma Scheme.PrimeDivisor.order_eq_order_restrict
    {X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X]
    (U : X.Opens) [Nonempty U] [IsIntegral U.toScheme]
    (Y : X.PrimeDivisor) (hYU : Y.point ∈ U)
    (f : X.functionField) :
    Scheme.RationalMap.order Y f
      = Scheme.RationalMap.order (Scheme.PrimeDivisor.restrictToOpen U Y hYU)
          ((Scheme.Opens.functionFieldIso U).inv.hom f)
```
or its mirror (whichever direction the L535 closure needs).

**SCOPE FENCE**: do NOT touch L538 (RR.1, Route C), L1108 (RR.1,
Route C), or the public signature of `rationalMap_order_finite_support`.
The L535 closure target itself is iter-203+ (requires signature
strengthening from `[IsLocallyNoetherian X]` to `[IsNoetherian X]`
or `[CompactSpace X]`, which is USER-blocked per the iter-198 L496-534
structural note).

**HARD BAR (per iter-202 `progress-critic route202` STUCK verdict
corrective)**: **steps (1) AND (2) BOTH axiom-clean**. The earlier
iter-202 plan-agent draft scoped step (1) as HARD BAR with step (2)
as PUSH-BEYOND; progress-critic flagged this as the substrate-only
PARTIAL pattern (5 consecutive substrate iters with 0 net sorry
reduction). Step (1) is the mechanism; step (2) is the sorry-
reducing endpoint. Landing step (1) without step (2) is NOT
acceptable: if the prover hits a hard blocker on step (2), report
the blocker explicitly and the next plan agent will dispatch a
follow-on WD lane; do NOT classify a step-(1)-only result as a
HARD BAR landing.
**PUSH-BEYOND**: begin sketching the terminal closure of L535 non-
zero branch (skeleton + signature-strengthening note documenting
the USER block). Do NOT attempt the full L535 inline closure
(USER-blocked sig strengthening).

**Blueprint**: `chapters/RiemannRoch_WeilDivisor.tex`
`def:functionFieldIso` (iter-202 NEW) +
`lem:rationalMap_order_finite_support` Sub-build 3 description.

## Lane AB-Path-B-Close (`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`)

**Mode**: `mathlib-build`. Helper budget = 2. Priority-1 (A.4.b root).

**Goal**: close `auslander_buchsbaum_formula_succ_pd` body via
Nat-induction restructuring; remove `private` from 3 declarations.

**Reference**: iter-201 task report at
`task_results/archive/iter-201/AlgebraicJacobian_Albanese_AuslanderBuchsbaum.lean.md`
lines 64--156 (Path B base case + inductive step decomposition);
`analogies/ab-stacks00mf.md` (persistent Path B verdict); Matsumura
§19 (Stacks 090V depth-pd formula), Bruns–Herzog Ch.1.

**Recipe** (~80-120 LOC, per iter-201 prover scout):

**Step 0 — Restructure**: rewrite `auslander_buchsbaum_formula_succ_pd`
to do `induction k generalizing M`. Generalize the surrounding setup
helpers (`exists_minimalSurjection_finite_localRing`,
`hasProjectiveDimensionLT_*`) so the IH is invocable on the kernel `K`
at smaller `k` inside the inductive step.

**Step 1 — Base case `k = 0` (pd M = 1)** (~50-80 LOC):
1. Minimal surjection `f : R^n →ₗ M`,
   `HasProjectiveDimensionLT (ker f) 1` via iter-200 helpers.
2. `K := ker f` finite projective over local Noetherian R, hence free:
   `Module.Flat.of_projective` + `Module.free_of_flat_of_isLocalRing`.
   Pick basis `φ : (Fin m → R) ≃ₗ[R] K`.
3. `A := K.subtype ∘ₗ φ.toLinearMap : (Fin m → R) →ₗ R^n`, image `K`.
4. Every entry of `A` lies in `𝔪 = Ann_R κ`: use
   `ideal_smul_top_pi_const` (L863) + the minimality clause
   `ker f ⊆ 𝔪 • ⊤_{Fin n → R}` from
   `exists_minimalSurjection_finite_localRing`.
5. Apply `Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`
   (iter-201 matrix-collapse, L1517) with `A`: every postcomposition
   `e.comp (mk₀ (ofHom A))` is zero in `Ext^p(κ, R^n)`.
6. Transport via `subtype = A ∘ₗ φ.symm.toLinearMap`: the
   postcomposition `Ext^p(κ, K) → Ext^p(κ, R^n)` (via SES first
   morphism) is also zero.
7. LES at `i = depth R - 1`: `Ext^{depth R - 1}(κ, M) →^δ
   Ext^{depth R}(κ, K)` is iso (next map zero by matrix-collapse +
   `Ext^{depth R - 1}(κ, R^n) = 0` since `depth R^n = depth R`).
   `Ext^{depth R}(κ, K) = Ext^{depth R}(κ, R^m) ≠ 0` (m ≥ 1,
   depth K = depth R). Conclude `depth M < depth R`, i.e.
   `depth M + 1 ≤ depth R`.
8. Matching `depth M + 1 ≥ depth R` from
   `depth_of_short_exact` part (2) on the SES.
9. Edge cases: `depth R = 0` (LES at i=0 contradiction); `m = 0`
   (i.e. `K = 0` → `f` iso → `M` projective → `pd M = 0`,
   contradicting `pd M = 1`).

**Step 2 — Inductive step `k + 1, k ≥ 1`** (~30-50 LOC, no
matrix-collapse needed):
1. Minimal surjection `f`, `HasProjectiveDimensionLT K (k+1)`.
2. `pd K = k` exactly (contrapositive of
   `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`).
3. IH on `K` at smaller `k`: `k + depth K = depth R`, so
   `depth K = depth R - k`.
4. `depth_of_short_exact` part (2): `depth M ≥ depth K - 1 =
   depth R - k - 1`, so `depth M + k + 1 ≥ depth R`.
5. `depth_of_short_exact` part (3): `depth K ≥ min(depth R^n,
   depth M + 1) = min(depth R, depth M + 1)`. If `depth R ≤
   depth R - k`, impossible for k ≥ 1. So `depth M + 1 ≤ depth R -
   k`, i.e. `depth M + k + 1 ≤ depth R`.
6. Combine: `(k+1) + depth M = depth R`.

**Step 3 — Promotions**: remove `private` from:
- `auslander_buchsbaum_formula_succ_pd` (this lemma; per blueprint
  iter-201 NOTE option (1)).
- `isDomain_of_regularLocal` (L2657; cross-file consumer = Lane COE
  Step A1 iter-203).
- `regularLocal_quotient_isRegularLocal_of_notMemSq` (L2293; same
  cross-file consumer).

These promotions are purely cosmetic — the declarations are already
axiom-clean. After promotion, verify `lake build` GREEN and
`#print axioms` shows only kernel triple for each.

**HARD BAR**: body of `_succ_pd` axiom-clean + 3 `private` removals.
**PUSH-BEYOND**: attempt `auslander_buchsbaum_formula` (the main
theorem at L1716) inductive step axiom-clean (the `pd = 0` base case
is already closed; the inductive step delegates to `_succ_pd`).

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex`
`lem:auslander_buchsbaum_formula_succ_pd` + iter-202 status update
paragraph + iter-202 AB-promotions commitment paragraph.

## Lane COE-Step-B-Bridges (`AlgebraicJacobian/Albanese/CodimOneExtension.lean`)

**Mode**: `mathlib-build`. Helper budget = 2. Priority-2 (A.4.c.0).

**Goal**: build the scheme-to-algebra bridges for L1061 closure
(Step B of the iter-201 prover Step B description, independent of
Step A1 which waits for iter-203 AB-helper promotions).

**Reference**: iter-201 task report at
`task_results/archive/iter-201/AlgebraicJacobian_Albanese_CodimOneExtension.lean.md`
lines 176--183 (Step B description); iter-199 Stage 6.B `cotangent
_iso_residue_tensor_kaehler_of_formallySmooth_residue` (L476) +
siblings; iter-200 `ringKrullDim_localization_atMaximal_MvPolynomial`;
Mathlib's `IsRegularLocalRing.iff_finrank_cotangentSpace`. Stacks
00TT (Jacobian criterion).

**Recipe** (~60-100 LOC of substrate, ~4 sub-bridges):

**Step B.a — SubmersivePresentation extractor** (~15-25 LOC):
extract the `SubmersivePresentation` from
`Algebra.IsStandardSmoothOfRelativeDimension Γ(Spec, U) Γ(X.left, V)`
via the iter-198 sub-gap (i) discharger
`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
(L834). Should be a packaging lemma giving access to the explicit
`P : Algebra.SubmersivePresentation _ _ ix sx` with concrete
`relativeDimension = n`.

**Step B.b — Maximal-ideal identification** (~10-20 LOC):
for the point `z : X.left` and the smooth affine V containing z,
identify the maximal ideal of `Γ(X.left, V)` corresponding to z.
This is the local-ring stalk-vs-section bridge already partially
present in Mathlib's `AlgebraicGeometry.StructureSheaf` API;
package as a project-local lemma exposing the maximal ideal +
the `IsLocalization.AtPrime` instance on the stalk.

**Step B.c — `Γ(Spec(.of kbar), U) = kbar` definitional bridge**
(~10-15 LOC): when `U = ⊤` (the standard `Spec kbar` open), the
sections are `kbar` definitionally. Project-local lemma making this
a clean rewrite for downstream consumers.

**Step B.d — Regular-stalk close** (~20-30 LOC): given a presentation
`P` over `kbar`, the iter-200 capstone
`ringKrullDim_localization_atMaximal_MvPolynomial` (Step 1+2 closed)
plus the iter-200 additive form
`ringKrullDim_quotient_add_eq_of_regular_sequence` plus the
**typed-sorry-for-Step-A1-witness** = the iter-203 Lane COE Step A1
target — combined with Mathlib's
`IsRegularLocalRing.iff_finrank_cotangentSpace` + the iter-199
Stage 6.B `finrank_cotangentSpace_of_bijective_algebraMap_residue`
substrate close `IsRegularLocalRing (X.left.presheaf.stalk z)`. The
typed sorry on the Step A1 piece is the iter-203 obligation.

**SCOPE FENCE**: do NOT attempt Lane COE Step A1 (Matsumura helper)
this iter — it depends on AB helper promotions which land in Lane AB
this iter; cross-lane file-state visibility makes a parallel Step A1
attempt guaranteed-incomplete. Leave Step A1 as a clearly-named typed
sorry in any L1061 inline-closure skeleton.

**HARD BAR**: at least 2 of Step B.a/b/c/d axiom-clean.
**PUSH-BEYOND**: 3+ sub-bridges + a sketch of the L1061 inline
closure assembly with Step A1 as a typed sorry (so iter-203 just has
to fill that one named sorry).

**Blueprint**: `chapters/Albanese_CodimOneExtension.tex`
`lem:smooth_to_regular_local_ring` +
`\subsec:stage6_iib_substrate_iter200` (iter-202 Step A1 reframe).

## Lane TS-Scaffold (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

**Mode**: `prove` (file-skeleton dispatch). Helper budget = 0.
Priority-2.5 (gates A.1.c body).

**Goal**: create the new Lean file
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` with declarations
for the 4 named blueprint targets, leave bodies as `sorry`, add the
import + namespace boilerplate, register in `AlgebraicJacobian.lean`.

**Reference**: blueprint chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (740 lines,
4 pinned declarations + 5 supporting helper lemmas).

**Targets** (4 pinned declarations from the blueprint):

1. `AlgebraicGeometry.Scheme.Modules.tensorObj` — the substrate
   binary operation on `Scheme.Modules X` (`def`, sorry body).
   Per blueprint `def:scheme_modules_tensorobj`.
2. `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` —
   bifunctoriality (`lemma`/`def`, sorry body).
   Per blueprint `lem:scheme_modules_tensorobj_functoriality`.
3. `AlgebraicGeometry.Scheme.Modules.monoidalCategory` — monoidal
   structure (`instance`, sorry body).
   Per blueprint `thm:scheme_modules_monoidal`.
4. `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` —
   the `AddCommGroup` instance on `PicSharp` built via the
   `tensorObj` substrate (`def`/`instance`, sorry body).
   Per blueprint `thm:rel_pic_addcommgroup_via_tensorobj`. THIS is
   the iter-204+ closure target for the Lane RPF L266-269
   `addCommGroup` `-- TODO + exact sorry` excuse-comment.

**Imports**: at minimum `Mathlib.AlgebraicGeometry.Modules.Sheaf`,
`Mathlib.CategoryTheory.Monoidal.Category`,
`AlgebraicJacobian.Picard.RelPicFunctor` (for the PicSharp
consumer). Boilerplate: `noncomputable section`, namespace
`AlgebraicGeometry.Scheme.Modules`.

**HARD BAR**: file compiles GREEN with at least 4 typed sorries
matching the blueprint pin signatures; new line in
`AlgebraicJacobian.lean` importing it.

**PUSH-BEYOND**: scaffold the 5 supporting helper lemma
declarations from `\subsec:tensorobj_supporting` too (typed
sorries; `lem:tensorobj_preserves_locally_trivial`,
`lem:tensorobj_inverse_invertible`,
`lem:tensorobj_lift_onproduct`,
`lem:pullback_compatible_with_tensorobj`).

**Blueprint**: `chapters/Picard_TensorObjSubstrate.tex` (already
complete iter-200).

**Critical: do NOT attempt proofs**. This is a scaffold lane —
producing compiling stub signatures is the entire deliverable.
Stub bodies should be `sorry`; do not write `by sorry` or
`exact sorry` (use the clean `:= sorry` form).
