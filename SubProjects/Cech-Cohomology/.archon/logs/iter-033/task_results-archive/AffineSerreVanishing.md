# AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

## Summary
- **Added axiom-clean: `standard_cover_cofinal` (1 new decl, lines ~144–199).** Tag 009L cofinality
  / standard-open refinement for `Spec R`. `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
- Declarations blocked: `toSheaf_preservesEpimorphisms` (1), and therefore the entire downstream
  `affine_surj_of_vanishing` → `affineCoverSystem` chain (steps 3–4). Precise blocker below.
- File sorry count: **0 → 0** (the gap-fill was attempted and reverted to a thorough documentation
  block rather than left as a `sorry`). File compiles `lake env lean … EXIT 0`.
- Pre-existing decls (iter-029) untouched and still present: `affine_faces_mem`,
  `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`.

## standard_cover_cofinal (line ~144) — RESOLVED, axiom-clean
- **Statement (built):**
  ```
  theorem standard_cover_cofinal {R : CommRingCat.{u}} (f : R) {α : Type u}
      (W : α → (Spec R).Opens)
      (hcov : (PrimeSpectrum.basicOpen f : (Spec R).Opens) ≤ ⨆ a, W a) :
      ∃ (n : ℕ) (g : Fin n → R) (φ : Fin n → α),
        (PrimeSpectrum.basicOpen f : (Spec R).Opens) = ⨆ i, PrimeSpectrum.basicOpen (g i) ∧
        ∀ i, (PrimeSpectrum.basicOpen (g i) : (Spec R).Opens) ≤ W (φ i)
  ```
- **Approach:** quasi-compactness of `D(f)` (`PrimeSpectrum.isCompact_basicOpen`) + basic-open basis
  (`PrimeSpectrum.isTopologicalBasis_basic_opens` +
  `TopologicalSpace.IsTopologicalBasis.exists_subset_of_mem_open`) +
  `IsCompact.elim_finite_subcover`. Index type `I := {p : R × α // B p.1 ≤ Uf ⊓ W p.2}` carries the
  witness `a`; finite `Finset I` repackaged to `Fin t.card` via `t.equivFin`.
- **Key technique (reuse downstream):** the `(Spec R).Opens` (carrier `↥(Spec R)`) vs
  `PrimeSpectrum R` defeq impedance is tamed by (a) `set Uf : (Spec R).Opens := PrimeSpectrum.basicOpen f`,
  and (b) a local `let B : R → (Spec R).Opens := fun r => PrimeSpectrum.basicOpen r`. Coercing a
  *variable* of type `(Spec R).Opens` to `Set ↥(Spec R)` works; coercing an inline
  `(PrimeSpectrum.basicOpen r : (Spec R).Opens)` ascription does NOT (it fails to insert the SetLike
  coercion). Bind to `Uf`/`B` first. Use `SetLike.coe_subset_coe`, `TopologicalSpace.Opens.mem_iSup`,
  `TopologicalSpace.Opens.coe_inf`, `Set.mem_iUnion₂.mp`, `Equiv.symm_apply_apply`.
- **Note for surj consumer:** statement is shaped to feed `ses_cech_h1` directly — `⨆ D(gᵢ) = D(f)`
  (so `iSup U = D(f)`, matching `s : H(op (iSup U))`) and `D(gᵢ) ≤ W (φ i)` (so local lifts on
  `W (φ i)` restrict to `D(gᵢ)`). `φ` and the `≤` are both essential for the lift-transport.

## toSheaf_preservesEpimorphisms (NOT added) — BLOCKED, alternatives exhausted
Blueprint `lem:to_sheaf_preserves_epi`. Target instance:
`(SheafOfModules.toSheaf X.ringCatSheaf).PreservesEpimorphisms`.

- **This is the load-bearing blocker for steps 3–4.** `affine_surj_of_vanishing` (and hence the
  `surj_of_vanishing` field of `affineCoverSystem`) needs it to pass from `Epi S.g` (in `X.Modules`)
  to local section surjectivity. Without it, neither surj nor the cover-system bundle can be built.
- **It is equivalent to `toSheaf` being right exact** (`PreservesFiniteColimits` / preserves
  cokernels), which reduces to: *"exactness in `SheafOfModules R` is detected on the underlying
  abelian sheaves."* Mathlib supplies only `PreservesFiniteLimits (toSheaf R)`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Limits`:118), `Faithful`, `Additive` — none suffice
  (high-`synthInstance.maxHeartbeats` `infer_instance` returns "failed to synthesize", not timeout:
  there is genuinely no instance path).
- **Every elementary route is circular or dead (all attempted in Lean):**
  1. `Functor.preservesEpimorphisms_of_preserves_shortExact_right` — its hypothesis requires
     `Epi (toSheaf S.g)`, exactly the goal. (Apply also needs `(toSheaf).Additive` which fails to
     synthesize during `apply` without an explicit `haveI` due to the topology-defeq issue.)
  2. `Sheaf.isLocallySurjective_iff_epi'` closes the goal *from* `IsLocallySurjective (toSheaf g)`,
     but extracting that from `Epi g` is the same missing content. NB: during `rw` the `Balanced
     (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat)` instance fails to synthesize even though a
     standalone `have … := inferInstance` succeeds (needs
     `set_option backward.isDefEq.respectTransparency false`, still insufficient). The *easy*
     direction `IsLocallySurjective → Epi` is fine via the instance
     `Sheaf.epi_of_isLocallySurjective` (needs only `J.HasSheafCompose (forget A)`, present) — so the
     ONLY gap is `Epi g (SheafOfModules) ⟹ IsLocallySurjective (toSheaf g)`.
  3. Stalk route (`TopCat.Presheaf.locally_surjective_iff_surjective_on_stalks`) needs stalk
     surjectivity of the underlying sheaf, i.e. stalk-exactness of `SheafOfModules` SES — same fact.
  4. Factorisation `toSheaf ≅ (forget ⋙ toPresheaf) ⋙ presheafToSheaf` (from
     `toSheafCompSheafToPresheafIso`, which is `Iso.refl`) does NOT help: `forget` (=
     `toPresheafOfModules`) is a *right* adjoint and does not preserve epis (a sheaf epi is only
     locally surjective, not objectwise).
- **Recommended next sub-task (dispatch separately):** build the standalone Mathlib-style lemma
  `(SheafOfModules.toSheaf R).PreservesFiniteColimits` (⟹ `.PreservesEpimorphisms`), by computing
  colimits in `SheafOfModules R` as the sheafification of the `PresheafOfModules`-level colimit
  (`HasColimits (SheafOfModules R)` via the sheafification adjunction) and transporting through
  `toSheaf` (using `toPresheaf : PresheafOfModules → Presheaf Ab` preserves colimits objectwise via
  the `ModuleCat R → Ab` coinduction right adjoint, and `presheafToSheaf` preserves colimits as a
  left adjoint). The needed glue is a coherence `toSheaf ∘ sheafification ≅ presheafToSheaf ∘
  toPresheaf`. Estimated several lemmas. This is the analogy `reparam.md` "Decision Q2-B" gap, here
  fully re-confirmed.

## affine_surj_of_vanishing / affineCoverSystem (NOT added) — gated on toSheaf gap-fill
- `affine_surj_of_vanishing` (`surj_of_vanishing` field): blueprint Step 1 explicitly routes through
  `toSheaf_preservesEpimorphisms` → `Sheaf.isLocallySurjective_iff_epi'` → cover with lifts →
  `standard_cover_cofinal` (DONE) → `ses_cech_h1` (CechBridge, DONE). All inputs are present EXCEPT
  the toSheaf gap-fill, so this is the next thing to build once that lands.
- `affineCoverSystem` (`def:affine_cover_system`): bundles `BasisCovSystem (Spec R)`. Fields:
  `faces_mem ← affine_faces_mem`; `injective_acyclic ← injective_cech_acyclicFam` (CechBridge, DONE)
  — both ready; `surj_of_vanishing ← affine_surj_of_vanishing` — blocked. Cannot construct the
  `BasisCovSystem` instance until `surj_of_vanishing` is available (all 5 fields required).
- Top theorems `affine_serre_vanishing` / `affine_cech_vanishing_qcoh` remain GATED additionally on
  the unconditional 01I8 `qcoh_iso_tilde_sections` (Route-P, separate lane) — not this lane.

## Needs blueprint entry
- **`AlgebraicGeometry.standard_cover_cofinal`** — NEW non-private lemma, file
  `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`. Already has blueprint label
  `lem:standard_cover_cofinal` (the `\lean{}` name matches). The proof relies on:
  `PrimeSpectrum.isCompact_basicOpen`, `PrimeSpectrum.isTopologicalBasis_basic_opens`,
  `TopologicalSpace.IsTopologicalBasis.exists_subset_of_mem_open`, `IsCompact.elim_finite_subcover`,
  `TopologicalSpace.Opens.{mem_iSup,coe_inf}`, `Finset.equivFin`. The realized Lean statement is the
  indexed-cover/refinement form (see above) — planner/reviewer should confirm the blueprint prose
  (currently phrased as abstract "cofinal system") matches this concrete indexed shape, and that
  `\uses{def:standard_affine_cover, lem:scheme_isBasis_affineOpens}` is still accurate (the proof
  actually uses `isTopologicalBasis_basic_opens`, not `Scheme.isBasis_affineOpens`).

## Why I stopped
- **Real progress:** 1 axiom-clean declaration added — `standard_cover_cofinal` (line ~144), step 2
  of the 02KG cover-system plan, fully proved + verified `{propext, Classical.choice, Quot.sound}`.
- **Partial/blocked:** `toSheaf_preservesEpimorphisms` (step 1) is the load-bearing blocker for
  steps 3–4. It is NOT a quick gap-fill: it is `toSheaf` right-exactness, requiring a multi-lemma
  colimit-computation in `SheafOfModules R` that Mathlib does not package (the analogue exists only
  for condensed modules over a *constant* ring, via `Sheaf J (ModuleCat R)`, not for sheaves of
  modules over a *sheaf* of rings). All four elementary routes were attempted in Lean and are
  circular or blocked (documented in-file and above). Precise next ingredient:
  `(SheafOfModules.toSheaf R).PreservesFiniteColimits`.
- Did not invent risky statements for `affine_surj_of_vanishing`/`affineCoverSystem`: both are
  genuinely gated on the toSheaf gap-fill (surj) and so cannot be built this iter.
- No external-LLM key in env (`archon-informal-agent.py` unavailable, per PROGRESS) — used LSP +
  Mathlib source inspection instead.
