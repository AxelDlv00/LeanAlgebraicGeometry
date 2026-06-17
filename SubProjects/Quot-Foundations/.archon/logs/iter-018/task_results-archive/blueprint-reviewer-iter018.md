# Blueprint Review Report — iter018

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-06-06  
**Chapters audited:** all chapters under `blueprint/src/chapters/`  
**Tools run:** `leandag build --json`, `leandag stats`, `leandag show isolated`, Lean LSP `#check` for `Algebra.adjoinCommRingOfComm`

---

## DAG Health Summary

| Metric | Value |
|---|---|
| Blueprint nodes | 187 |
| Lean-aux nodes | 1 |
| Edges | 360 |
| Proved (`\leanok`) | 97 (51.9 %) |
| Mathlib-backed (`\mathlibok`) | 30 |
| With sorry | 11 |
| Ready to formalize | 6 |
| Isolated nodes | **1** (0 blueprint) |
| Broken `\uses{}` | **0** |
| Unknown Lean names | 0 |

**DAG verdict: CLEAN.** Zero broken dependency links. The single isolated node is the known private `lean_aux` for `AlgebraicGeometry.GradedModule.finrank_comap_subtype` — exactly as expected, not a must-fix.

---

## Focus Area 1 — `Cohomology_FlatBaseChange.tex`: Five NEW Seam-2 Blocks

### Blocks present and located

| Label | Lines (approx.) | `\leanok` | `\uses{}` complete |
|---|---|---|---|
| `lem:base_change_mate_codomain_read_legs` | 1175–1225 | ✗ (new) | ✓ |
| `lem:gammaMap_pushforwardComp_hom_eq_id` | 1544–1563 | ✗ (new) | ✓ (`lem:gammaPushforwardIso`) |
| `lem:gammaMap_pushforwardComp_inv_eq_id` | 1565–1580 | ✗ (new) | ✓ |
| `lem:gammaMap_pushforwardCongr_hom` | 1582–1601 | ✗ (new) | ✓ |
| `lem:base_change_mate_fstar_reindex_legs` | 1603–1658 | ✗ (new) | ✓ (7 deps listed) |

All five blocks are present, correctly unformalized (no `\leanok`), and carry valid `\uses{}` chains.

### Step-(iii) mate-unwinding crux in `lem:base_change_mate_fstar_reindex_legs`

The directive gate asks: is the step-(iii) sequence (leg-reindex engine → absorb e-iso unit → Seam-1 unit value → land `def:base_change_mate_inner_value`) detailed enough to formalize?

**Verdict: YES — GATE PASS.**

The proof body at lines 1644–1657 describes step-(iii) as follows (condensed):

> *"The leg-reindex engine Lemma `lem:pullbackPushforward_unit_comp`, instantiated at **a = e, b = Spec ιA, N = M̃**, rewrites the unit factor η^{g'} together with the surviving `(pushforwardComp_{e, Spec ιA})^hom` coherence (whose Γ-collapse `lem:gammaMap_pushforwardComp_hom_eq_id` fires at this point) into the affine `(Spec ιA)`-unit followed by `(Spec ιA)_*` of the e-unit. Since e is an isomorphism, `lem:pullback_isEquivalence_of_iso` makes the e-unit invertible, hence absorbed into the codomain identification Θ_tgt. The surviving `(Spec ιA)`-unit has section value over Spec A equal to the algebraic unit η_M: m ↦ (1⊗1)⊗m of Seam 1 (`lem:base_change_mate_unit_value`); composing with the codomain read (`lem:base_change_mate_codomain_read_legs`) and reading over Spec R by restriction of scalars along ψ lands on ρ (`def:base_change_mate_inner_value`)."*

This narrates every Lean tactic step:
1. **Instantiation of `pullbackPushforward_unit_comp`** at (a=e, b=Spec ιA) is explicit.
2. **Which `gammaMap_pushforwardComp_hom_eq_id` fires** (the `hom` factor, not the `inv` factor) is specified.
3. **Absorption of the e-unit** via `lem:pullback_isEquivalence_of_iso` is named.
4. **Value of the `Spec ιA`-unit** is identified as `base_change_mate_unit_value` (Seam 1, already `\leanok`).
5. **Landing on `ρ`** via `def:base_change_mate_inner_value` is stated.

The `\uses{}` block wires all 7 required dependencies. The companion concrete form `lem:base_change_mate_fstar_reindex` (the literal-projection instantiation, already `\leanok`) confirms the abstract form's correctness by reference.

**No issues found** in the FBC Seam-2 chapter for this iter. The supporting infrastructure is all in place:
- `lem:pullbackPushforward_unit_comp` — `\leanok` ✓ (lines 1495–1536)
- `def:base_change_mate_inner_value` — `\leanok` ✓ (lines 1415–1436)
- `lem:base_change_mate_unit_value` — `\leanok` ✓ (lines 1358–1413)
- `lem:pullback_isEquivalence_of_iso` — `\leanok` ✓ (lines 1253–1268)

**FBC prover lane: CLEARED TO DISPATCH.**

---

## Focus Area 2 — `Picard_QuotScheme.tex`: Ambient Homogeneity Calculus + `adjoinCommRingOfComm`

### New blocks added this iter

The "Ambient homogeneity calculus" subsubsection (line 989 onward) adds **11 new definitions/lemmas** that were not previously present, plus enriches `lem:graded_subquotient_finite_transfer` and `lem:graded_subquotient_isRatHilb`. All new blocks are correctly unformalized.

Key new blocks and their completeness:

| Label | Status | Notes |
|---|---|---|
| `def:graded_raisesDegree` | Complete | Grading-ring-free abstraction of degree-1 multiplication |
| `lem:graded_raisesDegree_mem` | Complete | One-line from def |
| `lem:graded_decompose_raisesDegree` | Complete | "Load-bearing commutation" — proj_{i+1}(xm) = x(proj_i(m)) |
| `lem:graded_decompose_raisesDegree_zero` | Complete | proj_0(xm) = 0 |
| `lem:graded_comap_isHomogeneous` | Complete | Preimage of homogeneous is homogeneous |
| `lem:graded_map_isHomogeneous` | Complete | Image of homogeneous is homogeneous |
| `lem:graded_inf_isHomogeneous` | Complete | Lattice closure (inf) |
| `lem:graded_sup_isHomogeneous` | Complete | Lattice closure (sup) |
| `lem:graded_map_inf_degree_eq` | Complete | `(x·N) ∩ M_{n+1} = x·(N ∩ M_n)` |
| `lem:graded_sup_inf_degree_eq` | Complete | Distributive law `(P+Q) ∩ M_k = (P∩M_k)+(Q∩M_k)` |
| `lem:graded_subquotient_ker_coker` | Complete | Homogeneity + preservation + annihilation — all three parts |
| `lem:graded_subquotient_finite_transfer` | Complete | Finiteness transfer (enriched this iter) |
| `lem:graded_subquotient_isRatHilb` | Complete | Induction on r |

Already `\leanok` (prior iters, confirmed):
- `def:graded_subquotientHilb` ✓
- `lem:graded_subquotient_degreewise_diff` ✓
- `lem:graded_degreewise_finrank_diff` ✓

### Finiteness-encoding recipe verification

The directive asks to verify: "adjoinCommRingOfComm → aeval → Module.compHom → eval(last=0) surjection transfer".

The blueprint's `lem:graded_subquotient_finite_transfer` proof (lines 1385–1426) gives:

1. **adjoinCommRingOfComm step**: Use `Algebra.adjoinCommRingOfComm` to show the subalgebra `adjoin_κ{x_0,...,x_{r-1}}` is commutative (pairwise commutativity of generators → commutative adjoin). This gives `CommRing ↥(Algebra.adjoin κ s)`.

2. **aeval step**: Commutativity of the target is exactly what licenses `aeval` as a legal `κ`-algebra homomorphism `κ[t_0,...,t_{r-1}] → adjoin_κ{x_0,...,x_{r-1}} ⊆ End_κ(M)`. The blueprint states: *"Commutativity of A is exactly what makes the evaluation homomorphism... a legal κ-algebra homomorphism κ[t_0,...,t_{r-1}] → A: evaluation refuses the noncommutative End_κ(M) as a target."*

3. **Module.compHom step**: Restrict scalars along this evaluation to endow M with `κ[t_0,...,t_{r-1}]`-module structure, with `t_i · m = x_i m`.

4. **eval(last=0) surjection transfer** (lines 1401–1416): Since x = t_{r-1} annihilates K and C (shown in `lem:graded_subquotient_ker_coker`), the `κ[t_0,...,t_{r-1}]`-action on K and C factors through the surjection `κ[t_0,...,t_{r-1}] → κ[t_0,...,t_{r-2}]` (setting `t_{r-1} = 0`). Applying `lem:fg_restrictScalars_of_surjective_mathlib` transfers finiteness.

5. **Why free polynomial ring**: Correctly noted at lines 1418–1426 — must use the FREE polynomial ring `κ[t_0,...,t_{r-2}]`, not the subalgebra `adjoin_κ{x_0,...,x_{r-2}}`, to preserve the surjection structure at every inductive step.

**Mathematical soundness verdict: SOUND.** The route is correct. The induction is on length r, with the base case (r=0: M finite over κ, hence eventually-zero Hilbert function) handled by `lem:ratHilb_ofEventuallyZero`, and the inductive step consuming `lem:ratHilb_ofDiffEq`.

### `\mathlibok` anchor for `Algebra.adjoinCommRingOfComm` — CRITICAL FINDING

**`Algebra.adjoinCommRingOfComm` is DEPRECATED in current Mathlib.**

LSP verification:
```
#check @Algebra.adjoinCommRingOfComm
-- ⚠️ `Algebra.adjoinCommRingOfComm` has been deprecated: Use `Algebra.isMulCommutative_adjoin` instead
-- type: CommRing ↥(Algebra.adjoin R s)  [still exists as @[reducible] def via inferInstance]
```

The new non-deprecated lemma is `Algebra.isMulCommutative_adjoin` with type `IsMulCommutative ↥(Algebra.adjoin R s)` (not `CommRing`). The deprecated form is still present as a `@[reducible] def` that calls `inferInstance`, so the `CommRing` instance can still be obtained via either:
- (deprecated) `Algebra.adjoinCommRingOfComm κ hcomm`
- (current) `Algebra.isMulCommutative_adjoin κ hcomm` followed by `inferInstance : CommRing ↥(Algebra.adjoin κ s)`

The `\mathlibok` marker is **mathematically faithful** — the Mathlib content exists and the type delivered matches the blueprint claim. The module (`Mathlib.Algebra.Algebra.Subalgebra.Lattice`) is correct.

**Must-fix before prover dispatch**: Update the `\lean{}` pin from `Algebra.adjoinCommRingOfComm` to the non-deprecated name, and add a `% NOTE:` about the `inferInstance` bridge. Specifically in `lem:adjoinCommRingOfComm_mathlib`:

```latex
% NOTE (iter-018): Algebra.adjoinCommRingOfComm is deprecated; use
%   Algebra.isMulCommutative_adjoin + inferInstance instead.
%   The CommRing instance is still inferrable: given
%   (h : IsMulCommutative ↥(Algebra.adjoin κ s)) the CommRing instance
%   follows by inferInstance (Ring + IsMulCommutative → CommRing).
```

And in `lem:graded_subquotient_finite_transfer`, step 1 of the proof should say:
> Use `Algebra.isMulCommutative_adjoin` to obtain `IsMulCommutative ↥(adjoin_κ{x_i})`, then `haveI : CommRing ↥(adjoin_κ{x_i}) := inferInstance`.

The `\lean{Algebra.adjoinCommRingOfComm}` pin in the statement block should be changed to `\lean{Algebra.isMulCommutative_adjoin}`.

**SNAP-S2 prover lane: CLEARED TO DISPATCH** (with the annotation fix above applied first, or understood by the prover).

---

## Focus Area 3 — `Picard_FlatteningStratification.tex`: `lem:gf_noether_clear_denominators` (L4)

### L4 completeness and correctness

From the full read of the chapter (lines 1–1471), `lem:gf_noether_clear_denominators` at lines 381–482 (read in prior session) is confirmed complete and correct.

**Step 1 (Noether normalization over K)**: Uses `lem:noether_normalization_fg` (`\mathlibok`, `exists_finite_inj_algHom_of_fg` in Mathlib). The blueprint states: find an injective κ-algebra map K[Y_1,...,Y_m] → K⊗_A B, which by transport gives a finite ring map P_m → B[g^{-1}] for some g≠0 in A. Step 1 is adequate.

**Step 2 (Finset-fold of `gf_clear_one_denominator`)**: Applies `lem:gf_clear_one_denominator` iteratively over the finite set of generator images in the Noether image to clear their denominators simultaneously, producing a single g≠0 in A such that N_g is finite over A_g[X_1,...,X_m'] for some m' ≤ d. Step 2 is adequate.

**Verdict for GF prover lane gate: GATE PASS.** L4 is complete and correct for a prove pass on `exists_localizationAway_finite_mvPolynomial`.

### GF-alg chain status (context for prover dispatch)

The full dévissage chain is in the blueprint:
- L4 (`lem:gf_noether_clear_denominators`) — **blueprint complete, gate passed**
- L5b (`lem:gf_torsion_reindex`) — blueprint complete; has **important blocker note** at lines 1302–1311:

> *"NOTE (iter-016): the tower-descent helper `lem:gf_away_tower_descent` is now CLOSED and axiom-clean. The L5 sorry that remains is NOT a missing math step — it is a Lean elaboration blocker: the `OreLocalization` instance presentations on the localised quotient `(N ⧸ range φ)_g` emitted by `gf_torsion_reindex` are defeq but not instance-transparent-equal to the presentations the helper input expects. The clean fix is non-local: make `gf_torsion_reindex` emit its conclusion over the canonical `OreLocalization.*` instances. Do NOT re-dispatch a raw L5 prover round without that instance-alignment refactor first."*

This note is from iter-016. The GF prover lane (targeting `exists_localizationAway_finite_mvPolynomial` / L4) does not directly hit the L5 OreLocalization issue if the prove target is L4 specifically. However, the plan agent should be aware that L5 still carries this elaboration blocker.

---

## Per-Chapter Audit (All Chapters)

### `Cohomology_RegroupHelper.tex`

- `lem:base_change_regroup_linearEquiv` — `\leanok` ✓ (statement + proof)
- `\uses{lem:isPushout_cancelBaseChange_mathlib}` — anchor defined in `FlatBaseChange.tex` ✓
- Chapter: **complete** for its scope.

### `Cohomology_FlatBaseChange.tex`

- 64+ blocks; all pre-iter018 blocks have `\leanok` or `\mathlibok` as expected.
- 5 new Seam-2 blocks correctly unformalized (see Focus Area 1 above).
- `lem:base_change_mate_section_identity` — `\leanok` ✓ (the complete section-level identity)
- `thm:flat_base_change_pushforward` — `\leanok` ✓ (the FBC theorem itself)
- FBC-B (globalization beyond i=0) is not in scope this iter; no blocks for it are present (expected gated/next).
- Chapter: **complete for FBC-A scope**; FBC-B unstarted (expected).

### `Picard_FlatteningStratification.tex`

- GF algebraic chain (L1–L5 + geometric form): all blocks present.
- `thm:generic_flatness_algebraic` — `\leanok` ✓
- `thm:generic_flatness` — `\leanok` ✓ (geometric form, with sorry in Lean body — `with_sorry` count)
- OreLocalization elaboration issue at L5 is noted in blueprint (iter-016 note survives).
- Chapter: **complete** for its scope.

### `Picard_GrassmannianCells.tex`

- Affine charts through gluing, separatedness, properness: all `\leanok`.
- `def:gr_glued_scheme` — no `\leanok` marker (definition unformalized in Lean); correct, it's in the unmatched list.
- `lem:gr_separated`, `lem:gr_proper` — no `\leanok`; in unmatched list; consistent with QUOT-repr BLOCKED status.
- "Out of scope" section explicitly defers tautological quotient, representability, and relative Grassmannian.
- Chapter: **complete for its scope**; downstream representability correctly deferred.

### `Picard_QuotScheme.tex`

- `def:hilbert_polynomial` — `\leanok` ✓
- Rational Hilbert series blocks (`ratHilb_*`) — `\leanok` ✓ (6 blocks)
- Ambient subquotient calculus: 11 new blocks (see Focus Area 2 above).
- `def:quot_functor` — `\leanok` ✓
- `def:grassmannian_scheme` — `\leanok` ✓
- `thm:grassmannian_representable` — `\leanok` ✓ (skeleton; blocked note present in blueprint)
- Predicates: `def:has_proper_support`, `def:is_locally_free_of_rank` — `\leanok` ✓
- Annihilator machinery: `def:modules_annihilator` (bridged on `lem:qcoh_section_localization_basicOpen`), `lem:annihilator_localization_eq_map` — present.
- Chapter: **complete for QUOT-defs + SNAP-S2 scope**.

### `Picard_RelativeSpec.tex`

- 4 theorems: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base` — all `\leanok` ✓.
- Chapter: **complete** for its scope.

---

## Must-Fix Findings (This Iter)

### MF-1: `Algebra.adjoinCommRingOfComm` deprecated — update `\lean{}` pin

**File:** `blueprint/src/chapters/Picard_QuotScheme.tex`  
**Block:** `lem:adjoinCommRingOfComm_mathlib`  
**Severity:** Must-fix before SNAP-S2 prover dispatch (will generate deprecation warnings; replacement route differs slightly).

**Action for review agent:**
1. Change `\lean{Algebra.adjoinCommRingOfComm}` to `\lean{Algebra.isMulCommutative_adjoin}`.
2. Add annotation to statement:
   ```latex
   % NOTE (iter-018): Algebra.adjoinCommRingOfComm is deprecated in current Mathlib.
   % The replacement is Algebra.isMulCommutative_adjoin, which gives
   % IsMulCommutative ↥(Algebra.adjoin R s); the CommRing instance is then
   % inferInstance (Ring + IsMulCommutative → CommRing).
   ```
3. In `lem:graded_subquotient_finite_transfer` proof step 1, update the route to:
   > Use `Algebra.isMulCommutative_adjoin κ hcomm` to obtain `IsMulCommutative ↥(adjoin_κ{x_i})`, then derive `CommRing ↥(adjoin_κ{x_i})` by `haveI := inferInstance`.

The `\mathlibok` marker on `lem:adjoinCommRingOfComm_mathlib` is still valid (Mathlib content exists). Only the `\lean{}` pin needs updating.

---

## No Other Must-Fix Findings

The following are observations, not blockers:

- **`lem:graded_subquotient_ker_coker` lacks `\leanok`** (expected — new block, unformalized).
- **`thm:grassmannian_representable` proof sketch in blueprint**: The blueprint itself notes the proof is blocked (RepresentableBy gap). Consistent with QUOT-repr BLOCKED status. No action needed this iter.
- **L5 OreLocalization elaboration issue** (`lem:gf_polynomial_core`): Noted in blueprint (iter-016 comment). The GF prover lane targets L4, not L5 directly; the plan agent should not dispatch an L5 prover without the instance-alignment refactor first.
- **`unmatched_lean` count = 42**: These are `\mathlibok` anchors whose Lean names don't exist locally (they're in Mathlib, not the project files). This is correct and expected for `\mathlibok` nodes.

---

## Prover Lane Dispatch Gates

| Lane | Gate Status | Notes |
|---|---|---|
| **FBC-A** (Seam-2 mate-unwinding) | ✅ **CLEARED** | Step-(iii) description sufficient; all deps `\leanok` |
| **GF-alg** (L4 prove pass) | ✅ **CLEARED** | L4 complete + correct; be aware L5 OreLocalization issue |
| **SNAP-S2** (subquotient induction) | ✅ **CLEARED** | Recipe sound; apply MF-1 fix first (update `\lean{}` pin) |
| FBC-B | ⏳ NEXT (gated, not dispatched) | — |
| GF-geo | ⏳ NEXT (gated) | — |
| SNAP-S1/S3 | ⏳ NEXT | `def:sectionGradedRing` unmatched (expected) |
| QUOT-repr | 🔒 BLOCKED | RepresentableBy gap in blueprint + Lean |

---

## Appendix: leandag `unmatched_lean` List

The following `\mathlibok` declarations in the blueprint have Lean names pointing to Mathlib (not locally defined), which is expected. All 42 unmatched entries are legitimate Mathlib aliases:

Key ones verified:
- `lem:pullbackSpecIso_mathlib` → `AlgebraicGeometry.pullbackSpecIso` ✓
- `lem:cancelBaseChange_mathlib` → `TensorProduct.AlgebraTensorModule.cancelBaseChange` ✓
- `lem:isPushout_cancelBaseChange_mathlib` → `Algebra.IsPushout.cancelBaseChange` ✓
- `lem:adjoinCommRingOfComm_mathlib` → `Algebra.adjoinCommRingOfComm` ⚠️ DEPRECATED (see MF-1)
- `lem:flat_preserves_equalizer_mathlib` → `LinearMap.tensorEqLocusEquiv` ✓
- `lem:noether_normalization_fg` → `exists_finite_inj_algHom_of_fg` ✓
- `lem:fp_free_descent` → `Module.FinitePresentation.exists_free_localizedModule_powers` ✓
