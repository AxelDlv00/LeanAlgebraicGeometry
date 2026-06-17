# Lean ↔ Blueprint Check Report

## Slug
quot

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (1162 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (2202 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: partial — the Lean type takes `(_L _F : X.Modules)` without encoding `proper support` or the `coherent sheaf` condition; the blueprint requires a coherent sheaf with schematic support proper over S, and a line bundle L. Return type `Polynomial ℚ` (applied to `_s : S`) is correct. The weakening is explicitly acknowledged in the file's docstring as a skeleton placeholder for iter-176+.
- **Proof follows sketch**: N/A — body is `sorry` by documented design
- **notes**: Blueprint has `\leanok` correctly (sorry counts as "formalized" in statement position). This is one of the 4 protected stubs. No must-fix.

---

### `\lean{AlgebraicGeometry.sectionGradedRing}` (chapter: `def:sectionGradedRing`)
- **Lean target exists**: no — not present in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no `\leanok`. Blocked on absent sheaf-tensor-product infrastructure (acknowledged by `% NOTE:` in blueprint). Expected coverage debt.

---

### `\lean{AlgebraicGeometry.sectionGradedModule}` (chapter: `def:sectionGradedModule`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` in blueprint. Expected debt.

---

### `\lean{AlgebraicGeometry.sectionGradedModule_fg}` (chapter: `lem:sectionGradedModule_fg`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` in blueprint. Expected debt.

---

### `\lean{Polynomial.existsUnique_hilbertPoly}`, `\lean{Submodule.finrank_quotient_add_finrank}`, `\lean{PowerSeries.invOneSubPow}` (Mathlib anchors)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — `\mathlibok` correctly placed in all three blocks
- **Proof follows sketch**: N/A
- **notes**: No issue.

---

### `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}` (chapter: `lem:gradedHilbertSerre_rational`)
- **Lean target exists**: no — not a Lean declaration in this file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no `\leanok`; has `% NOTE:` documenting that the ambient-subquotient route sidesteps the Mathlib gap. Expected debt; will be assembled from `lem:graded_subquotient_isRatHilb` + section-module connection.

---

### `\lean{AlgebraicGeometry.coeff_invOneSubPow_one_mul}` (chapter: `lem:coeff_invOneSubPow_one_mul`)
- **Lean target exists**: yes, but as `private lemma coeff_invOneSubPow_one_mul` (line 430) — the name `AlgebraicGeometry.coeff_invOneSubPow_one_mul` does **not** appear in the exported Lean environment because of the `private` modifier
- **Signature matches**: yes — `(F : ℚ⟦X⟧) (n : ℕ) : ((invOneSubPow ℚ 1).val * F).coeff n = ∑ k ∈ Finset.range (n+1), F.coeff k` matches the blueprint statement exactly
- **Proof follows sketch**: yes — proof uses `invOneSubPow_val_succ_eq_mk_add_choose`, Cauchy product, and `sum_range_reflect`, consistent with the blueprint's "proved directly from the identity invOneSubPow(ℚ,1) = ∑ X^m and the Cauchy product"
- **notes**: The `\lean{...}` tag names a `private` declaration; the name cannot be resolved by environment lookup (e.g. `lean_verify`, LSP hover-by-name). `sync_leanok` apparently found it by file scan rather than name lookup. Blueprint `\leanok` is present. **See Major finding M1.**

---

### `\lean{AlgebraicGeometry.rationalHilbert_antidiff}` (chapter: `lem:rationalHilbert_antidiff`)
- **Lean target exists**: yes, `private lemma rationalHilbert_antidiff` (line 450) — same `private` caveat as above
- **Signature matches**: yes — hypotheses and conclusion match blueprint prose exactly
- **Proof follows sketch**: yes — telescoping identity, window-sum split at N+2, constant-absorption via `C·(1-X)^e`, explicit numerator `p = C·(1-X)^e + q`; matches the blueprint proof precisely
- **notes**: Same `private`-name issue. **See Major finding M1.**

---

### `\lean{AlgebraicGeometry.IsRatHilb}` (chapter: `def:ratHilb`)
- **Lean target exists**: yes, `private def IsRatHilb` (line 534) — `private` caveat applies
- **Signature matches**: yes — `∃ (p : Polynomial ℚ) (N : ℕ), ∀ n, N < n → f n = ((p : ℚ⟦X⟧) * (invOneSubPow ℚ d).val).coeff n` exactly as in blueprint
- **Proof follows sketch**: N/A (definition)
- **notes**: **See Major finding M1.**

---

### `\lean{AlgebraicGeometry.IsRatHilb.ofEventuallyZero}`, `.bump`, `.sub`, `.shiftRight`, `.antidiff`, `.ofDiffEq` (chapter: `lem:ratHilb_*`)
- **Lean target exists**: yes for all six, as `private` lemmas (lines 538–610)
- **Signature matches**: yes for all six — each matches its blueprint statement precisely:
  - `ofEventuallyZero`: eventually-zero → IsRatHilb(f,0) ✓
  - `bump`: IsRatHilb(f,d) → IsRatHilb(f,d+1) ✓
  - `sub`: IsRatHilb(f,d) ∧ IsRatHilb(g,d) → IsRatHilb(f-g,d) ✓
  - `shiftRight`: IsRatHilb(f,d) → IsRatHilb(n↦f(n-1),d) ✓
  - `antidiff`: (IsRatHilb g e) ∧ (H diff = g) → IsRatHilb(H, e+1) ✓
  - `ofDiffEq`: IsRatHilb(h_C,d) ∧ IsRatHilb(h_K,d) ∧ diff-eq → IsRatHilb(h_M,d+1) ✓
- **Proof follows sketch**: yes for all six — all proofs are complete and match the blueprint sketches
- **notes**: All `private`; **see Major finding M1.** All have correct `\leanok` markers.

---

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` (chapter: `thm:hilbertPoly_of_sectionModule`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no `\leanok`. Awaits `sectionGradedModule` + `gradedHilbertSerre_rational`.

---

### Mathlib dependency anchors (`\lean{Submodule.IsHomogeneous}`, `\lean{Ideal.homogeneous_span}`, `\lean{LinearMap.finrank_range_add_finrank_ker}`, `\lean{Submodule.FG.restrictScalars_of_surjective}`, `\lean{SetLike.IsHomogeneousElem.graded_smul}`, `\lean{Algebra.isMulCommutative_adjoin}`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — `\mathlibok` correctly placed; `Algebra.isMulCommutative_adjoin` correctly noted (memory record: replaces deprecated `adjoinCommRingOfComm`)
- **notes**: No issue.

---

### `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep}` (chapter: `lem:graded_homogeneousSubmodule_iSupIndep`)
- **Lean target exists**: yes (line 633, `theorem homogeneousSubmodule_inf_iSupIndep`)
- **Signature matches**: yes — `iSupIndep fun i => ℳ i ⊓ p`, in the ambient module `M`, matching "the family n↦M_n∩p is independent"
- **Proof follows sketch**: yes — uses `(DirectSum.Decomposition.isInternal ℳ).submodule_iSupIndep.mono fun _ => inf_le_left`; blueprint says "inherited from the independent grading family M_n via M_n∩p ≤ M_n"
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq}` (chapter: `lem:graded_homogeneousSubmodule_iSup_eq`)
- **Lean target exists**: yes (line 649)
- **Signature matches**: yes — `⨆ i, (ℳ i ⊓ p) = p` for homogeneous `p`
- **Proof follows sketch**: yes — two-sided inclusion via `iSup_le` and `DirectSum.sum_support_decompose`; matches blueprint sketch
- **notes**: `\leanok` correct. Correctly avoids `IsInternal` on the subtype (per memory record on graded-quotient-module-isdefEq pathology).

---

### `\lean{AlgebraicGeometry.GradedModule.subquotientHilb}` (chapter: `def:graded_subquotientHilb`)
- **Lean target exists**: yes (line 712, `def subquotientHilb`)
- **Signature matches**: yes — `subquotientHilb ℳ N N' n : ℚ := (((finrank κ ↥(N⊓ℳn) : ℤ) - (finrank κ ↥(N'⊓ℳn) : ℤ)) : ℚ)`; matches "hilb(n) = (dim_κ(N∩M_n) - dim_κ(N'∩M_n)) ∈ ℚ"
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct. The blueprint `def:graded_subquotientHilb` block also describes the *SubquotientDatum* structure (endomorphisms, finiteness) but pins only `subquotientHilb`. The `SubquotientDatum` structure (line 1112) is not yet pinned. **See Major finding M2** (finiteness condition mismatch) and **Unreferenced declarations** section.

---

### `\lean{AlgebraicGeometry.GradedModule.RaisesDegree}` (chapter: `def:graded_raisesDegree`)
- **Lean target exists**: yes (line 700)
- **Signature matches**: yes — `RaisesDegree ℳ x : Prop := ∀ n, (ℳ n).map x ≤ ℳ (n+1)` matches "x(M_n) ⊆ M_{n+1}"
- **Proof follows sketch**: N/A
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.RaisesDegree.mem}` (chapter: `lem:graded_raisesDegree_mem`)
- **Lean target exists**: yes (line 703, with `omit [DirectSum.Decomposition ℳ]`)
- **Signature matches**: yes — `hx : RaisesDegree ℳ x → hm : m ∈ ℳ n → x m ∈ ℳ (n+1)`
- **Proof follows sketch**: yes — one-liner via `hx n (Submodule.mem_map_of_mem hm)`
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.decompose_raisesDegree}` (chapter: `lem:graded_decompose_raisesDegree`)
- **Lean target exists**: yes (line 719)
- **Signature matches**: yes — `(DirectSum.decompose ℳ (x m) (i+1) : M) = x (DirectSum.decompose ℳ m i)`
- **Proof follows sketch**: yes — decompose m into graded components, use linearity of x and `decompose_of_mem_same/ne`; matches blueprint
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.decompose_raisesDegree_zero}` (chapter: `lem:graded_decompose_raisesDegree_zero`)
- **Lean target exists**: yes (line 744)
- **Signature matches**: yes — `(DirectSum.decompose ℳ (x m) 0 : M) = 0`
- **Proof follows sketch**: yes — each summand lands in M_{j+1}, none in M_0; matches "j+1 ≥ 1" argument
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.comap_isHomogeneous}` (chapter: `lem:graded_comap_isHomogeneous`)
- **Lean target exists**: yes (line 735)
- **Signature matches**: yes — `(N'.comap x).IsHomogeneous ℳ`
- **Proof follows sketch**: yes — uses `decompose_raisesDegree`; matches blueprint
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.map_isHomogeneous}` (chapter: `lem:graded_map_isHomogeneous`)
- **Lean target exists**: yes (line 755)
- **Signature matches**: yes — `(N.map x).IsHomogeneous ℳ`
- **Proof follows sketch**: yes — case split on degree 0 vs i+1; matches blueprint
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.inf_isHomogeneous}` (chapter: `lem:graded_inf_isHomogeneous`)
- **Lean target exists**: yes (line 803)
- **Signature matches**: yes — `(p ⊓ q).IsHomogeneous ℳ`
- **Proof follows sketch**: yes — component-by-component using both homogeneity hypotheses
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.sup_isHomogeneous}` (chapter: `lem:graded_sup_isHomogeneous`)
- **Lean target exists**: yes (line 812)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `decompose_add`, `add_mem_sup`
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.map_inf_degree_eq}` (chapter: `lem:graded_map_inf_degree_eq`)
- **Lean target exists**: yes (line 767)
- **Signature matches**: yes — `N.map x ⊓ ℳ (n+1) = (N ⊓ ℳ n).map x`
- **Proof follows sketch**: yes — two-sided inclusion using `decompose_raisesDegree` and `Submodule.IsHomogeneous.mem_iff`
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.sup_inf_degree_eq}` (chapter: `lem:graded_sup_inf_degree_eq`)
- **Lean target exists**: yes (line 784)
- **Signature matches**: yes — `(P ⊔ Q) ⊓ ℳ k = (P ⊓ ℳ k) ⊔ (Q ⊓ ℳ k)`
- **Proof follows sketch**: yes — decompose-add trick with homogeneity of P and Q
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}` (chapter: `lem:graded_subquotient_ker_coker`)
- **Lean target exists**: no — no declaration named `subquotient_ker_coker` in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The content is split across 8 separate declarations (`ker_isHomogeneous`, `coker_isHomogeneous`, `ker_le`, `coker_le`, `ker_annihilate`, `coker_annihilate`, `comap_map_le_of_commute`, `map_map_le_of_commute` — all in the "known issues" list). Blueprint has no `\leanok` (correct). The `\lean{...}` pin names a non-existent declaration; the tag should either be removed or the 8 component declarations should be pinned separately. **See Major finding M3.**

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_degreewise_diff}` (chapter: `lem:graded_subquotient_degreewise_diff`)
- **Lean target exists**: yes (line 914)
- **Signature matches**: yes — `subquotientHilb ℳ N N' (n+1) - subquotientHilb ℳ N N' n = subquotientHilb ℳ N (N' ⊔ N.map x) (n+1) - subquotientHilb ℳ (N ⊓ N'.comap x) N' n` for all `n` (not just n ≫ 0)
- **Proof follows sketch**: yes — uses linear maps φ and g into M⧸N', range equality, kernel identification via `finrank_comap_subtype`, inclusion-exclusion `hIE`, rank-nullity `RN`/`RG`, integer cast `key`; matches the kernel/cokernel identification in blueprint
- **notes**: `\leanok` correct. Notably the Lean proves this for ALL n (no threshold), which is slightly stronger than the blueprint's statement but consistent. No sorry.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_finite_transfer}` (chapter: `lem:graded_subquotient_finite_transfer`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok`. Expected debt; the polyModule infrastructure (new this iter) sets up the scaffolding needed.

---

### `\lean{AlgebraicGeometry.GradedModule.degreewise_finrank_diff}` (chapter: `lem:graded_degreewise_finrank_diff`)
- **Lean target exists**: yes (line 670)
- **Signature matches**: yes — `(finrank κ W : ℤ) - finrank κ V = (finrank κ (W ⧸ LinearMap.range φ) : ℤ) - finrank κ (LinearMap.ker φ)`
- **Proof follows sketch**: yes — uses `LinearMap.finrank_range_add_finrank_ker` and `Submodule.finrank_quotient_add_finrank` with `omega`; one-liner as described in blueprint
- **notes**: `\leanok` correct. Blueprint labels this D5, Lean is in `GradedModule` namespace (correct).

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational}` (chapter: `lem:graded_subquotient_isRatHilb`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: One of the 4 protected stubs. Blueprint has no `\leanok`. This is the top-level induction that ties together the toolkit; its formalization requires `subquotient_finite_transfer` and `subquotient_ker_coker` (as a bundled structure, i.e. `SubquotientDatum`).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: `def:modules_annihilator`)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `(F : X.Modules) : X.IdealSheafData`; the `ofIdeals` construction assembles the family `U ↦ Ann_{Γ(X,U)}(Γ(F,U))` as an ideal sheaf, matching "defined on affine opens"
- **Proof follows sketch**: yes — body is `IdealSheafData.ofIdeals fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1)` exactly as described; the basic-open coherence is sidestepped by `ofIdeals`, matching the blueprint's description
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (chapter: `lem:modules_annihilator_ideal_le`)
- **Lean target exists**: yes (line 305)
- **Signature matches**: yes — `(annihilator F).ideal U ≤ Module.annihilator Γ(X, U.1) Γ(F, U.1)`
- **Proof follows sketch**: yes — one-liner `IdealSheafData.ideal_ofIdeals_le`
- **notes**: `\leanok` correct.

---

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (chapter: `lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes (line 362)
- **Signature matches**: yes — `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` under `IsLocalization S Rₚ`, `IsLocalizedModule S f`, `Module.Finite R M`; matches blueprint exactly
- **Proof follows sketch**: yes (and then some) — the full proof is present (lines 362–422), covering both inclusions with the "common denominator" argument (using `IsLocalization.mk'_surjective`, finset product `U = ∏ u_i`, `hUa`, `heq`) and the reverse direction via `Ideal.map_le_iff_le_comap`; matches the blueprint proof sketch closely
- **notes**: `\leanok` correct. This is the most complete proof in the file (no sorry).

---

### `\lean{AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen}` (chapter: `lem:isLocalization_basicOpen_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — `\mathlibok` correctly placed
- **notes**: No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (chapter: `lem:qcoh_section_localization_basicOpen`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok`. This is the QCoh localization bridge that gates `annihilator_ideal` (the full characterization of the annihilator on affine opens). Expected debt.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: `def:schematic_support`)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — `(F : X.Modules) : Scheme.{u}` defined as `(annihilator F).subscheme`; matches "closed subscheme cut out by Ann(F)"
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (chapter: `def:schematic_support_immersion`)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes — `schematicSupport F ⟶ X` as `(annihilator F).subschemeι`
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.IsProper}` (chapter: `lem:isProper_mathlib`)
- **Lean target exists**: yes (Mathlib) — `\mathlibok` correctly placed
- **notes**: No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: `def:has_proper_support`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `{S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop := IsProper (schematicSupportι F ≫ f)`; matches blueprint
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: `def:is_locally_free_of_rank`)
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — `∃ (ι : Type u) (U : ι → X.Opens), (⨆ i, U i = ⊤) ∧ ∀ i, Nonempty ((Modules.pullback (U i).ι).obj M ≅ SheafOfModules.free (ULift.{u} (Fin d)))`; matches "open cover with M|_{U_i} ≅ O^d"
- **notes**: `\leanok` correct.

---

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: partial — return type `(Over S)ᵒᵖ ⥤ Type u` matches "(Sch/S)^op ⥤ Set"; but coherence, flatness, and proper-support conditions are not encoded in the type. Weakened by design as skeleton.
- **Proof follows sketch**: N/A — body is `sorry`
- **notes**: Blueprint `\leanok` correct. Protected stub; no must-fix.

---

### `\lean{CategoryTheory.Functor.IsRepresentable}` (chapter: `lem:functor_is_representable_mathlib`)
- **Lean target exists**: yes (Mathlib) — `\mathlibok` correctly placed
- **notes**: No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(_V : S.Modules) (_d : ℕ) : (Over S)ᵒᵖ ⥤ Type u`; matches "functor of rank-d quotients"; body is `sorry`
- **notes**: Blueprint `\leanok` correct. Protected stub.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225)
- **Signature matches**: partial (significant) — Lean says `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)` but blueprint claims "representable by a smooth projective S-scheme of relative dimension d(r-d) with Plücker embedding". Smoothness, properness, relative dimension d(r-d), tautological rank-d quotient, and Plücker embedding are all absent from the Lean type.
- **Proof follows sketch**: N/A — body is `sorry`
- **notes**: Blueprint acknowledges this explicitly via `% NOTE: The Lean statement ... is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d)...`. Blueprint `\leanok` correct. Protected stub.

---

## Red flags

### Placeholder / suspect bodies

The following carry `:= sorry` and are **by design** per the directive:
- `Scheme.hilbertPolynomial` (line 123–126): skeleton for iter-176+; blueprint explicitly describes as placeholder
- `Scheme.QuotFunctor` (line 161–165): skeleton
- `Scheme.Grassmannian` (line 198–201): skeleton
- `Scheme.Grassmannian.representable` (line 225–228): skeleton; blueprint `% NOTE:` acknowledges

**No unexpected sorries found.** All sorry bodies are accompanied by explicit iter-176 skeleton notes in docstrings. No excuse-comments of the "wrong but works for now" variety detected.

### Axioms / Classical.choice on non-trivial claims
- `annihilator_isLocalizedModule_eq_map` uses `Classical.dec _` inside `homogeneousSubmodule_iSup_inf_eq` (line 651) and `classical` in several GradedModule proofs — all appropriate uses for decidability of membership; none on non-trivial mathematical claims. No `axiom` declarations introduced.

---

## Unreferenced declarations (informational)

The following Lean declarations in this file have **no** `\lean{...}` reference in the blueprint. Per the directive, the 20 new declarations from the "known issues" list are assessed collectively below rather than individually.

### Substantive declarations without blueprint pins (expected coverage debt from known issues):
1. `GradedModule.ker_isHomogeneous` (line 834) — implements part of `lem:graded_subquotient_ker_coker`
2. `GradedModule.coker_isHomogeneous` (line 839) — same
3. `GradedModule.ker_le` (line 847) — same
4. `GradedModule.coker_le` (line 854) — same
5. `GradedModule.ker_annihilate` (line 861) — same
6. `GradedModule.coker_annihilate` (line 866) — same
7. `GradedModule.comap_map_le_of_commute` (line 874) — same
8. `GradedModule.map_map_le_of_commute` (line 888) — same
9. `GradedModule.polyEndHom` (line 986) — supports `lem:graded_subquotient_finite_transfer`
10. `GradedModule.polyEndHom_X` (line 999) — helper for `polyEndHom`
11. `GradedModule.polyEndHom_C` (line 1009) — helper for `polyEndHom`
12. `GradedModule.polyModule` (line 1024) — supports finiteness transfer
13. `GradedModule.polyModule_X_smul` (line 1029) — helper
14. `GradedModule.polyModule_C_smul` (line 1037) — helper
15. `GradedModule.polyModule_isScalarTower` (line 1048) — helper
16. `GradedModule.polySubmodule` (line 1062) — implements ambient stable submodule for polynomial ring
17. `GradedModule.polySubmodule_coe` (line 1085) — simp lemma for above
18. `GradedModule.SubquotientDatum` (line 1112) — **should be pinned** in `def:graded_subquotientHilb`; see M2
19. `GradedModule.SubquotientDatum.hilb` (line 1141) — part of `def:graded_subquotientHilb`
20. `GradedModule.finiteDimensional_of_mvPolynomial_isEmpty_finite` (line 1148) — base-case helper; should be pinned under `lem:graded_subquotient_isRatHilb`

### Pure helpers (no blueprint pin needed):
- `GradedModule.finrank_comap_subtype` (private, line 901) — internal auxiliary for D6 proof

---

## Blueprint adequacy for this file

### Coverage
Counting declarations with corresponding `\lean{...}` blocks:
- **Formalized with blueprint pin**: 31 declarations (including Mathlib re-exports and skeletons with sorry)
- **Formalized without blueprint pin** (all in "known issues" list): 20 declarations
- **Not yet formalized** (no Lean code): 9 blueprint blocks (`sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `gradedHilbertSerre_rational`, `hilbertPolynomialOfSectionModule`, `qcoh_section_localization_basicOpen`, `subquotient_ker_coker` [as bundled decl], `subquotient_finite_transfer`, `subquotient_hilbertSeries_rational`)

### Known-issues collective assessment

**Were the blueprint's `lem:graded_subquotient_*` / `def:graded_subquotientHilb` blocks adequate to guide the 20 new declarations?**

Yes, substantially:

- `def:graded_subquotientHilb` (lines 952–987) gave clear guidance for `SubquotientDatum` and `subquotientHilb`. The Lean implementation faithfully captures all listed fields: `N`, `N'`, `hle`, `hN`, `hN'`, `t : Fin r → End κ M`, `hcomm`, `hraise`, `hpresN`, `hpresN'`, and a finiteness condition.

- `lem:graded_subquotient_ker_coker` (lines 1199–1280) gave detailed guidance for the 8 component lemmas (`ker_isHomogeneous` through `map_map_le_of_commute`). The blueprint's 4-item list (homogeneity of new pairs, nesting, preservation by remaining endomorphisms, annihilation) maps directly onto these lemmas.

- `lem:graded_subquotient_finite_transfer` proof sketch (lines 1395–1436) provided the conceptual roadmap for `polyEndHom`, `polyModule`, `polySubmodule`: the blueprint explicitly says "the evaluation homomorphism at the generators [is] a legal κ-algebra homomorphism κ[t₀,...,t_{r-1}] → A; composing with the inclusion endows M with the structure of a module over κ[t₀,...,t_{r-1}]", and the "Why the free polynomial ring" paragraph (lines 1428–1436) anticipates the exact technical choice made in Lean.

**Does `SubquotientDatum` faithfully realize `def:graded_subquotientHilb`?**

Mostly yes, with one prose mismatch. The blueprint says (lines 968–970): "a finiteness condition: *M* is a finite module over the polynomial ring κ[t₀,...,t_{r-1}] acting through the t_i."

The Lean `hfin` (lines 1134–1137) instead records finiteness of the **subquotient N/N'** over `MvPolynomial (Fin r) κ`, not of M itself. This is mathematically sound (the induction works: the base case uses `finiteDimensional_of_mvPolynomial_isEmpty_finite` on N/N'; the transfer uses Noetherianness of the polynomial ring to get finiteness of K and C from finiteness of N/N'). However, the blueprint prose is imprecise: it should say "the subquotient N/N' is finite over κ[t₀,...,t_{r-1}]". This is a blueprint update item.

### Proof-sketch depth
**Adequate** overall for completed proofs:
- The `IsRatHilb` toolkit and `lem:rationalHilbert_antidiff` proof sketches were detailed enough for complete Lean proofs.
- The ambient homogeneity calculus (`decompose_raisesDegree`, `map_inf_degree_eq`, `sup_inf_degree_eq`, `subquotient_degreewise_diff`) had adequate sketch depth.
- The `subquotient_degreewise_diff` proof sketch is exemplary: it names the two linear maps φ and g, derives the kernel and cokernel identifications, and applies D5 explicitly. The Lean proof follows this exactly.

**Under-specified** items (none blocking for this iter, but noted for future provers):
- `lem:graded_subquotient_isRatHilb` proof sketch is present but the base-case step ("M is a finite κ-vector space → hilb(n)=0 for n≫0") does not mention how `FiniteDimensional κ M_n` of each piece follows from `Module.Finite` of N/N' over the empty polynomial ring — the `finiteDimensional_of_mvPolynomial_isEmpty_finite` helper fills this gap but has no blueprint block.

### Hint precision
**Partially broken** — see Major finding M1 (private declarations named by public `\lean{...}` tags) and Major finding M3 (`subquotient_ker_coker` naming a non-existent declaration).

### Generality
**Matches need** for all fully formalized declarations. The `polyModule`/`polySubmodule` using `MvPolynomial (Fin r) κ` (free polynomial ring, not subalgebra) is the correct generality and is supported by the blueprint's proof sketch.

### Recommended chapter-side actions
1. Update `def:graded_subquotientHilb` to say finiteness is of **N/N'** over the polynomial ring, not of M.
2. Add a `\lean{AlgebraicGeometry.GradedModule.SubquotientDatum}` pin in `def:graded_subquotientHilb` (alongside the existing `\lean{...subquotientHilb}` pin).
3. Replace the broken `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}` hint with separate pins for the 8 component declarations (or restructure to a bundled declaration matching the existing `\lean{...}` tag).
4. Change the `IsRatHilb` toolkit declarations from `private` to at least `protected` (or add `private` notation in the blueprint hint), so `\lean{AlgebraicGeometry.IsRatHilb}` etc. resolve correctly.
5. Add a blueprint block for `finiteDimensional_of_mvPolynomial_isEmpty_finite` (base-case helper for `lem:graded_subquotient_isRatHilb`).
6. Add blueprint blocks for `polyEndHom`, `polyModule`, `polySubmodule`, `SubquotientDatum.hilb` under `lem:graded_subquotient_finite_transfer` or a new `subsec:polyModuleAPI` subsection.

---

## Severity summary

### must-fix-this-iter
*None.* No placeholder bodies on declarations the blueprint claims are substantive (without a documented skeleton note). No excuse-comments. No axioms. No weakened-wrong definitions (the sorry skeletons are documented and authorized). No blueprint adequacy failure severe enough to claim the chapter could not have guided the Lean code.

### major

**M1 — `private` modifier breaks `\lean{...}` name resolution for the IsRatHilb toolkit**

Declarations `coeff_invOneSubPow_one_mul` (line 430), `rationalHilbert_antidiff` (line 450), `IsRatHilb` (line 534), `IsRatHilb.ofEventuallyZero` (line 538), `IsRatHilb.bump` (line 547), `IsRatHilb.sub` (line 562), `IsRatHilb.shiftRight` (line 575), `IsRatHilb.antidiff` (line 586), `IsRatHilb.ofDiffEq` (line 602) are all declared `private`. The blueprint's `\lean{AlgebraicGeometry.IsRatHilb}` etc. name the public namespace path, but `private` declarations are NOT registered under that name in the Lean environment. Any external tool using `lean_verify`, `lean_hover_info`, or name-based `sync_leanok` will fail to find them. The `\leanok` markers may rest on file-scan heuristics rather than verified name lookup. **Action:** make these declarations non-private (or use `private` with a `% NOTE:` in the blueprint hint and update the `\lean{...}` tag to a non-private alias).

**M2 — Blueprint `def:graded_subquotientHilb` finiteness-condition prose mismatch**

Blueprint lines 968–970 say "a finiteness condition: *M* is a finite module over κ[t₀,...,t_{r-1}]". Lean `SubquotientDatum.hfin` stores finiteness of the *subquotient N/N'* (not M) over `MvPolynomial (Fin r) κ`. The Lean choice is mathematically sound and works for both base and inductive steps (as evidenced by `finiteDimensional_of_mvPolynomial_isEmpty_finite`). The blueprint prose should be corrected to match. **Action:** a blueprint-writing pass should update `def:graded_subquotientHilb` to say "the subquotient N/N' is finite over κ[t₀,...,t_{r-1}]".

**M3 — `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}` pins a non-existent declaration**

The blueprint's `lem:graded_subquotient_ker_coker` has `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}` but no such declaration exists. The content is in 8 separate lemmas. Blueprint has no `\leanok` (correct), but the broken `\lean{...}` hint means blueprint infrastructure cannot verify or hyperlink to the Lean code. **Action:** either (a) introduce a bundled `subquotient_ker_coker` wrapper declaration, or (b) replace the `\lean{...}` hint with 8 separate `\lean{...}` tags for the component declarations.

**M4 — `def:graded_subquotientHilb` misses `\lean{}` pin for `SubquotientDatum`**

The `def:graded_subquotientHilb` definition describes the full SubquotientDatum structure (homogeneous pair, family of endomorphisms, finiteness) but pins only `\lean{AlgebraicGeometry.GradedModule.subquotientHilb}` (the Hilbert function). The `SubquotientDatum` structure (line 1112), `SubquotientDatum.hilb` (line 1141), and `finiteDimensional_of_mvPolynomial_isEmpty_finite` (line 1148) have no blueprint pins. **Action:** add `\lean{AlgebraicGeometry.GradedModule.SubquotientDatum}` and `\lean{...SubquotientDatum.hilb}` pins in the definition block.

### minor

**m1 — `Scheme.hilbertPolynomial` / `Scheme.QuotFunctor` weakened types**

Both omit `proper support` and `coherent sheaf` conditions from the Lean type (documented skeleton choices). The blueprint prose requires these conditions. This is acknowledged in file docstrings and the blueprint's iter commentary but not formally marked as a known typing debt via `% NOTE:`.

**m2 — `Grassmannian.representable` significantly weaker than chapter theorem**

The Lean type `∃ Y : Over S, Nonempty ((Grassmannian V d).RepresentableBy Y)` omits smoothness, properness, relative dimension d(r-d), tautological quotient, and Plücker embedding. The blueprint has a `% NOTE:` acknowledging this. No further action needed this iter.

**m3 — 8 `ker_/coker_`-family declarations and 9 polyModule declarations lack blueprint blocks**

These 17 declarations (from the "known issues" list, minus `SubquotientDatum`/`.hilb`/`finiteDimensional`) implement content that the blueprint describes narratively in `lem:graded_subquotient_ker_coker` and `lem:graded_subquotient_finite_transfer` but does not pin individually. Stale coverage that the plan agent intends to address next iter.

---

**Overall verdict**: The file and chapter are in good alignment for an intermediate skeleton iteration — all completed proofs (IsRatHilb toolkit, D5/D6, homogeneity calculus, annihilator infrastructure) faithfully realize their blueprint blocks, and `\leanok` markers are accurate; the 4 authorized sorry-stubs are correctly handled; the main actionable issues are three broken `\lean{...}` hints (private-name resolution, `subquotient_ker_coker` pointing to a non-existent declaration, missing `SubquotientDatum` pin) and one prose mismatch in `def:graded_subquotientHilb` — all **major** but not must-fix, and all addressable in a single blueprint-writing pass.
