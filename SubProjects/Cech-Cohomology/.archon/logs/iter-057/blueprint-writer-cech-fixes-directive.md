# Blueprint-writer directive — `Cohomology_CechHigherDirectImage.tex`

Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. Address the four must-fix
findings of the iter-057 blueprint review (which gate prover dispatch for `CechSectionIdentification.lean`
and `AffineSerreVanishing.lean`). Do NOT add `\leanok` to anything (the deterministic sync owns it).
You MAY add `\mathlibok` ONLY on a genuine Mathlib re-export anchor (see item 4d).

Strategy context (the slice that matters): the project proves `cech_computes_higherDirectImage` via Route A
(acyclic-resolution comparison). Two inputs are under active prover work: (P5a-resolution) the augmented
Čech complex resolves F — its local discharge is the Sub-brick A section identification + contractibility
(items 1–2 below); (P5a-consumer) open-immersion acyclicity via general-affine-open Serre vanishing, whose
last residual is the change-of-ring Čech seed (item 3 below).

---

## Must-fix 1 — Re-state `lem:cechSection_complex_iso` (line ~7667) to the AUGMENTED complex

The current statement `D ≅ D'` is FALSE: the consumer's `D` is the augmented Čech complex evaluated at V
(`D.X 0 = Γ(V,F)` because `def:cech_augmented_complex` augments by `F`), while the non-augmented
`D'` has `D'.X 0 = ∏_i Γ(U_i∩V, F)`. They differ at degree 0.

**Corrected statement:** `D` (the evaluated augmented complex) is isomorphic, as a cochain complex, to
`D'_aug := (sectionCechComplex U'·).augment ε hε`, where:
- `U'_σ := coverInterOpen 𝒰 σ ⊓ V` (equivalently `U'_j = coverOpen 𝒰 j ⊓ V` on singletons);
- `ε : Γ(V,F) → ∏_i Γ(U_i∩V, F)` is the restriction product map `t ↦ (t|_{U_i∩V})_i` (the evaluation at
  V of the Čech augmentation map `F → C⁰`);
- `hε : ε ≫ d⁰ = 0` (the cosimplicial augmentation identity `ε ≫ δ₀ = ε ≫ δ₁`).

**Proof sketch (extend the existing one):** the degree-(−1) term of `D'_aug` is `Γ(V,F)`, identified with
`D`'s degree-0-of-the-augmentation by the identity map `Γ(V,F)=Γ(V,F)`; the degree-p isomorphisms (p≥0)
are `lem:pushPull_eval_prod_iso`; the augmentation maps correspond by construction of the Čech augmentation
(`def:cech_augmentation`/`def:cech_augmented_complex`). The differential match for p≥0 is the existing
`lem:section_cech_objd_apply` alternating-sum argument (unchanged). Update the `\lean{}` pin to name the
declaration that builds the AUGMENTED iso (the prover will create it; use the placeholder
`\lean{AlgebraicGeometry.cechSection_complex_iso}` and a `% NOTE: build target — augmented form` line, since
the current Lean decl carries the false non-augmented signature and must be re-signed by the prover).
Remove the stale `% NOTE:` mis-spec warning and replace it with the corrected description.

## Must-fix 2 — Re-state `lem:cechSection_contractible` (line ~7709) to the AUGMENTED complex + add the augmentation-node argument

The current `Homotopy (𝟙 D') 0` is FALSE (the non-augmented `D'` is not contractible: a one-member cover
`{V}` gives `H⁰(D') = Γ(V,F) ≠ 0`).

**Corrected statement:** `Homotopy (𝟙 D'_aug) 0` — a contracting homotopy on the AUGMENTED complex
`D'_aug = (sectionCechComplex U'·).augment ε hε`, under the hypothesis `V ≤ coverOpen 𝒰 i_fix` for some
fixed index `i_fix`.

**Proof sketch (must include the augmentation node explicitly):**
- *Positive degrees (p ≥ 1):* because `V ≤ U_{i_fix}`, the restricted family `U'_j = U_j ∩ V` has a
  maximum `U'_{i_fix} = V`, so prepending `i_fix` to any multi-index σ does not change the open
  (`U'_{i_fix,σ} = U'_σ`). The de-privatized dependent-coefficient combinatorial Čech engine
  (`depDiff`/`depHomotopy`/`depHomotopy_spec` of `lem:cech_acyclic_affine` — cited only as the Lean home
  of the `dep*` engine, NOT for its standard-cover conclusion) supplies the prepend-`i_fix` homotopy with
  the prepend map acting as the identity on each coefficient, giving `dh + hd = id` in degrees ≥ 1.
- *Augmentation node (degrees −1/0) — the piece the engine CANNOT supply:* the homotopy component
  `h⁻¹ : D'_aug.X 0 = ∏_i Γ(U_i∩V,F) → Γ(V,F) = D'_aug.X (−1)` is the `i_fix`-th coordinate projection
  `π_{i_fix}`. Verify `d⁻¹ ∘ h⁻¹ + h⁰ ∘ d⁰ = id` at degree 0: for `s ∈ ∏_i Γ(U_i∩V,F)`,
  `(ε(π_{i_fix} s))_j = (s_{i_fix})|_{U_j∩V}`; combined with the degree-0 contribution of the
  non-augmented engine homotopy, this reconstructs `s_j`. The identity is the sheaf-equalizer fact: since
  `V ≤ U_{i_fix}` the section `s_{i_fix}` restricts to `U_j∩V`, and the prepend-`i_fix` shift on the
  non-augmented part plus this restriction sum to the identity. State this as an explicit degree-0
  computation, NOT a delegation to `depHomotopy`. Use `\lean{AlgebraicGeometry.cechSection_contractible}`
  with a `% NOTE: build target — augmented form` line; replace the stale mis-spec `% NOTE:`.

Update `lem:cechSection_isZero_homology` (line ~7749) only if its `\uses{}` or prose needs to track the
augmented `D'_aug` (its statement `IsZero (Hᵖ D)` is unchanged; ensure the proof cites the corrected 1+2).

---

## Must-fix 3 — New change-of-ring seed block + fix `lem:affine_serre_vanishing_general_open`

`lem:affine_serre_vanishing_general_open` (line ~8323) proof claims condition (3) "holds by the same
quasi-coherent seed as in `lem:affine_serre_vanishing`". This is WRONG: for a general affine open
`V = ⨆_i D(g_i)`, `Γ(V)` is NOT a localization `R_f`, so the distinguished-`D(f)` seed
`sectionCech_homology_exact_of_localizationAway` does NOT apply.

**Add a NEW lemma block `lem:affine_cech_vanishing_general_seed`** stating the change-of-ring seed:
> Let `R` be a ring, `M : ModuleCat R`, `g : Fin n → R` a finite family, and suppose `V := ⨆_i D(g_i)`
> is an affine open of `Spec R`. Then for every `p > 0`, the section Čech complex of `~_R M` over the
> cover `{D(g_i)}` has vanishing positive homology:
> `IsZero (cechCohomology (fun i => D(g_i)) ((toPresheafOfModules).obj (tilde M)) p)`.

**Proof sketch — route B1** (verified by the mathlib-analogist; read `analogies/genaffine-cech-seed.md`
for the full decomposition and citations, and `analogies/02kg-residual-changeofbase.md` for the done D(f)
ladder it mirrors):
- Set `S := Γ(V, 𝒪_V)`, the coordinate ring of the affine open `V`; `φ : R → S` the restriction map,
  `ḡ_i := φ(g_i)`.
- The `D(g_i) ⊆ V` correspond under `V ≅ Spec S` (`Scheme.isoSpec`/`IsAffineOpen.isoSpec`,
  `lem:isoSpec_scheme_mathlib`) to basic opens `D_S(ḡ_i)` of `Spec S`, and `{ḡ_i}` **span the unit ideal
  of `S`** (because the `D_S(ḡ_i)` cover `Spec S = V`).
- Identify the section Čech complex of `~_R M` over `{D(g_i)}` (degree-p term
  `∏_σ Γ(D(∏_k g_{σk}), ~M) = ∏_σ M_{∏g_{σk}}`) with the **standard-cover (full-span)** section Čech
  complex over `Spec S` of `~_S (M ⊗_R S)` (term `∏_σ (M⊗_R S)_{∏ḡ_{σk}}`), via the per-σ localization
  iso `M_{∏g_{σk}} ≅ (M⊗_R S)_{∏ḡ_{σk}}`. This iso is `IsLocalizedModule` base-change: `Γ(D(g)) = R_g`
  (`IsAffineOpen.isLocalization_basicOpen`) `= S_{ḡ}` (`IsAffineOpen.isLocalization_of_eq_basicOpen` with
  `(Spec R).basicOpen ḡ = D(g)`), and `(M⊗_R S)_{ḡ}` is the base change of `M` along `R → S → S_ḡ`
  (`Mathlib.RingTheory.Localization.BaseChange`: `isLocalizedModule_iff_isBaseChange`, `IsBaseChange.comp`).
- Apply the EXISTING full-span result `sectionCech_affine_vanishing` / `sectionCech_homology_exact`
  (the `{R}[CommRing R]`-polymorphic core, re-instantiated over `S` with the spanning family `ḡ`), then
  transport the vanishing back across the ladder of per-σ isos
  (`Function.Exact.of_ladder_addEquiv_of_exact`, mirroring `sectionCechAbExact`).

Use `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen}` (the name the prover will build,
co-located in `CechAcyclic.lean`) with a `% NOTE: build target` line. `\uses{}` it on:
`lem:isoSpec_scheme_mathlib`, `lem:cech_acyclic_affine` (the polymorphic dDiff core),
`lem:affine_cech_vanishing_qcoh` (full-span seed), and the localization base-change Mathlib facts. Add a
`% SOURCE` citation to Stacks 01HV (`Γ(D(f),~M)=M_f`) — read from `references/stacks-schemes.tex` lines
692–728 — quoting verbatim, and Stacks 02KE/`lemma-cech-cohomology-quasi-coherent-trivial` for the
standard-cover vanishing (read from `references/stacks-coherent.tex`).

Then **revise `lem:affine_serre_vanishing_general_open`'s proof** (item (3) bullet at line ~8366): replace
"holds by the same quasi-coherent seed as in `lem:affine_serre_vanishing`" with a reference to the new
`lem:affine_cech_vanishing_general_seed` (via `qcoh_iso_tilde_sections` for arbitrary quasi-coherent F, as
`lem:affine_cech_vanishing_general_of_tildeVanishing` below does). Add the new label to its `\uses{}`.

---

## Must-fix 4 — Coverage debt: author blocks for the 7 isolated `lean_aux` nodes + wire-ups

All in `Cohomology_CechHigherDirectImage.tex`. Use accurate `\uses{}` reflecting the Lean proofs (see the
iter-056 `task_results/AffineSerreVanishing.md` "Needs blueprint entry" section for each helper's deps).
Each block: statement in project notation + `\label` + `\lean{<exact name>}` + at least a one-line informal
proof. Place them in the Need#2 region (near `lem:affine_serre_vanishing_general_open`).

a) `def:affine_cover_system_general` — `\lean{AlgebraicGeometry.affineCoverSystemGeneral}`: the
   `BasisCovSystem` on `Spec R` with basis = all affine opens, covers = finite standard covers `{D(g_i)}`
   whose union is affine. Generalizes `def:affine_cover_system`. `\uses{lem:affine_faces_mem,
   lem:affine_surj_of_vanishing_affine, lem:injective_cech_acyclic}`.
b) `lem:standard_cover_cofinal_affine` — `\lean{AlgebraicGeometry.standard_cover_cofinal_affine}`: for any
   affine open `V ⊆ Spec R` and any open cover of `V`, a finite standard cover `{D(g_i)}` of `V` refines
   it. General-affine companion of `lem:standard_cover_cofinal` (uses `IsAffineOpen.isCompact` in place of
   `PrimeSpectrum.isCompact_basicOpen`). Cite Stacks 009L.
c) `lem:affine_surj_of_vanishing_affine` — `\lean{AlgebraicGeometry.affine_surj_of_vanishing_affine}`: the
   `surj_of_vanishing` field for the general system. `\uses{lem:ses_cech_h1,
   lem:standard_cover_cofinal_affine}`.
d) `lem:isAffineOpen_specBasicOpen` — `\lean{AlgebraicGeometry.isAffineOpen_specBasicOpen}`: every basic
   open `D(r) ⊆ Spec R` is affine. Its proof is a 2-line wrap of `basicOpenIsoSpecAway` (`D(r)≅Spec R[1/r]`)
   + `IsAffine.of_isIso` — author as a normal short lemma block (NOT `\mathlibok`, since it carries a
   project proof). If you instead find an exact Mathlib re-export (`AlgebraicGeometry.isAffineOpen_basicOpen`
   or similar) that the Lean decl literally is, THEN mark `\mathlibok`; verify the name first.
e) `lem:affine_cech_vanishing_general_of_tildeVanishing` —
   `\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh_general_of_tildeVanishing}`: reduces general-affine
   quasi-coherent Čech vanishing to the tilde seed via `qcoh_iso_tilde_sections`. Analogue of
   `lem:affine_cech_vanishing_qcoh_of_tildeVanishing`. `\uses{lem:qcoh_iso_tilde_sections,
   lem:affine_cech_vanishing_general_seed}`.
f) `lem:affine_serre_vanishing_general_of_seed` —
   `\lean{AlgebraicGeometry.affine_serre_vanishing_general_of_seed}`: `HasVanishingHigherCech
   (affineCoverSystemGeneral R) F` ⟹ general-affine Serre vanishing, via `cech_eq_cohomology_of_basis`.
   `\uses{lem:cech_to_cohomology_on_basis, def:affine_cover_system_general}`.
g) `lem:affine_serre_vanishing_general_of_tildeVanishing` —
   `\lean{AlgebraicGeometry.affine_serre_vanishing_general_of_tildeVanishing}`: assembles f) from e). This
   is the working form behind `lem:affine_serre_vanishing_general_open`.
   `\uses{lem:affine_cech_vanishing_general_of_tildeVanishing, lem:affine_serre_vanishing_general_of_seed}`.
h) **Wire-up (no new block):** add `AlgebraicGeometry.jShriekOU_homEquiv_nat` to the existing `\lean{...}`
   list of `lem:absolute_cohomology_zero_natural` (line ~3138) — it is the private precursor of the public
   `jShriekOU_homEquiv_naturality` already pinned there.
i) **`% NOTE` (no block):** near `lem:cech_acyclic_affine`, note that `AlgebraicGeometry.CechAcyclic.affine`
   (the sorry-bearing dead sibling of `cechAugmented_exact`) is subsumed by the iter-053 toSheaf bridge and
   is intentionally left as a dead placeholder.

After your edits, the chapter must have NO remaining `% NOTE:` claiming a statement is false/mis-specified,
and every block in items 1–4 must have a complete statement + `\uses{}` + informal proof a prover can
formalize. References authorized: `references/**` (for the Stacks 01HV/02KE/009L verbatim quotes).
