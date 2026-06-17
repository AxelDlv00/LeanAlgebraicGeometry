# Blueprint-reviewer directive — iter-057

Whole-blueprint audit (read the entire blueprint under `blueprint/src/`). Standard per-chapter
completeness + correctness checklist, plus the items below that this iter's prover work surfaced.

## Specific items to scrutinize (HARD GATE depends on these)
The consolidated chapter `Cohomology_CechHigherDirectImage.tex` (declares `% archon:covers` for 15
Lean files, including `CechSectionIdentification.lean` and `AffineSerreVanishing.lean`) carries known
issues from iter-056 prover work:

1. **Stubs 5/6 mis-specification (must-fix).** `lem:cechSection_complex_iso` (line ~7667) and
   `lem:cechSection_contractible` (line ~7709) are flagged `% NOTE:` as PROVABLY FALSE as written: the
   consumer needs the AUGMENTED complex `D` (`D.X 0 = Γ(V,F)`), but the lemmas are stated for the
   NON-augmented `D'` (`D'.X 0 = ∏_i Γ(U_i∩V,F)`). `D ≅ D'` is false; `D'` is not contractible
   (one-member cover ⟹ `H⁰(D')=Γ(V,F)≠0`). The correct targets are `D ≅ D'.augment ε hε` and
   `Homotopy (𝟙 D'_aug) 0`, with the degree-0 augmentation node needing a sheaf-equalizer argument
   beyond the degrees-≥1 `depHomotopy` engine. Confirm whether these blocks are now correct or still
   need a writer re-spec, and report exactly what the corrected statements + proof sketches must say.

2. **The Need#2 seed is glossed over (completeness gap).** `lem:affine_serre_vanishing_general_open`
   (line ~8323, a `_TODO` build target) claims in its proof that condition (3) of
   `cech_eq_cohomology_of_basis` "holds by the same quasi-coherent seed as in
   `lem:affine_serre_vanishing`". This is INACCURATE: for the enlarged cover system (basis = all affine
   opens, covers of a general affine open V), the seed is a genuine CHANGE-OF-RING Čech vanishing
   (V≅SpecΓ(V), Γ(V) NOT a localization of R) — the existing distinguished-D(f) seed
   `sectionCech_homology_exact_of_localizationAway` does NOT apply (V is not D(f) for any single f).
   Report whether the chapter needs a NEW lemma block for this change-of-ring seed with its own proof
   sketch, and what that sketch must contain.

3. **Coverage debt (9 unmatched Lean decls).** These prover-created helpers have no blueprint entry
   (isolated in the DAG): `CechAcyclic.affine`, `affineCoverSystemGeneral`,
   `affine_cech_vanishing_qcoh_general_of_tildeVanishing`, `affine_serre_vanishing_general_of_seed`,
   `affine_serre_vanishing_general_of_tildeVanishing`, `affine_surj_of_vanishing_affine`,
   `isAffineOpen_specBasicOpen`, `jShriekOU_homEquiv_nat`, `standard_cover_cofinal_affine`. Note which
   need blueprint blocks authored (so the planner can dispatch a writer).

Report your per-chapter checklist with explicit `complete:`/`correct:` verdicts and a must-fix list, so
the planner can decide the HARD GATE for `CechSectionIdentification.lean` and `AffineSerreVanishing.lean`.
