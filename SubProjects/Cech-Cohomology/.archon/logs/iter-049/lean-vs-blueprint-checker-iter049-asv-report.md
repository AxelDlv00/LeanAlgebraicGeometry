# Lean ↔ Blueprint Check Report

## Slug
iter049-asv

## Iteration
049

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (covers this file via `% archon:covers AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` at line 11)

---

## Per-declaration

### `\lean{AlgebraicGeometry.affine_faces_mem}` (chapter: `lem:affine_faces_mem`, line 3288)
- **Lean target exists**: yes (`affine_faces_mem`, file line 42)
- **Signature matches**: yes — `{R} {ι} (s : ι → R) {p} (σ : Fin (p+1) → ι) : (⨅ k, D(s(σ k))) ∈ range (fun f => D f)` faithfully encodes "finite intersections of distinguished opens are distinguished"
- **Proof follows sketch**: yes — the blueprint proof says `D(f₁…fₙ) = D(f₁)∩…∩D(fₙ)` by induction; Lean closes with `basicOpen_sprod.symm` (one-liner)
- **notes**: `\leanok` present; fully closed

### `\lean{AlgebraicGeometry.standard_cover_cofinal}` (chapter: `lem:standard_cover_cofinal`, line 3321)
- **Lean target exists**: yes (file line 167)
- **Signature matches**: yes — `standard_cover_cofinal {R} (f : R) {α} (W : α → Opens) (hcov : D f ≤ ⊔ W) : ∃ n g φ, D f = ⊔ D(g i) ∧ ∀ i, D(g i) ≤ W(φ i)` matches the blueprint's "refine to a finite standard subcover"
- **Proof follows sketch**: yes — quasi-compactness + basic-open basis, as the blueprint prescribes
- **notes**: `\leanok` present; fully closed

### `\lean{AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan}` (chapter: `lem:cover_datum_bridge`, line 3617)
- **Lean target exists**: yes (file line 58)
- **Signature matches**: yes — `coverOpen (affineOpenCoverOfSpanRangeEqTop s hs).openCover i = D(s i)`, the open-level identity
- **Proof follows sketch**: yes — unfolds via `Spec.map` and `localization_away_comap_range`
- **notes**: `\leanok` present; fully closed

### `\lean{AlgebraicGeometry.affine_injective_acyclic}` (chapter: `lem:affine_injective_acyclic`, line 3650)
- **Lean target exists**: yes (file line 79)
- **Signature matches**: yes — `[Finite ι] (s : ι → R) (hs : Ideal.span(range s) = ⊤) [Injective I] (q : ℕ) (hq : 0 < q) : IsZero (cechCohomology (D ∘ s) (toPresheaf I) q)` as described
- **Proof follows sketch**: yes — routes through `coverOpen_affineOpenCoverOfSpan` and `injective_cech_acyclic`
- **notes**: `\leanok` present; fully closed

### `\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}` (chapter: `lem:toSheaf_preservesFiniteColimits`, line 3488)
- **Lean target exists**: yes (file line 119)
- **Signature matches**: yes — `PreservesFiniteColimits (SheafOfModules.toSheaf R)` under `[HasWeakSheafify J Ab] [J.WEqualsLocallyBijective Ab]`, matching the blueprint's description of the right-exact dual
- **Proof follows sketch**: yes — builds via the sheafification square `PresheafOfModules.sheafificationCompToSheaf (𝟙 R.obj)`, exactly as the blueprint's two-step construction prescribes
- **notes**: blueprint block has NO `\leanok` even though the Lean proof is fully closed. The `sync_leanok` phase should add `\leanok` next cycle. Minor state-tracking lag, not a prover error.

### `\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}` (chapter: `lem:to_sheaf_preserves_epi`, line 3546)
- **Lean target exists**: yes (file line 151)
- **Signature matches**: yes — `(SheafOfModules.toSheaf R).PreservesEpimorphisms` as a corollary of `toSheaf_preservesFiniteColimits`
- **Proof follows sketch**: yes — one-line corollary via `WalkingSpan`
- **notes**: same missing `\leanok` as above; sync_leanok will fix next cycle

### `\lean{AlgebraicGeometry.affine_surj_of_vanishing}` (chapter: `lem:affine_surj_of_vanishing`, line 3396)
- **Lean target exists**: yes (file line 233)
- **Signature matches**: yes — takes `S : ShortComplex (Spec R).Modules`, `hS : S.ShortExact`, the Čech-vanishing hypothesis on `S.X₁`, and `f : R`; concludes surjectivity of the section map over `D f`
- **Proof follows sketch**: yes — matches the blueprint's `ses_cech_h1` route: local surjectivity via `toSheaf_preservesEpimorphisms`, standard-cover refinement via `standard_cover_cofinal`, then `ses_cech_h1`
- **notes**: `\leanok` present; fully closed

### `\lean{AlgebraicGeometry.affineCoverSystem}` (chapter: `def:affine_cover_system`, line 3695)
- **Lean target exists**: yes (file line 373, `noncomputable def affineCoverSystem`)
- **Signature matches**: yes — `affineCoverSystem (R : CommRingCat.{u}) : BasisCovSystem (Spec R)` with `B = range D`, `Cov = standard covers of any D(f)`, three fields discharged as described
- **Proof follows sketch**: yes — fields match: `faces_mem ← affine_faces_mem`, `surj_of_vanishing ← affine_surj_of_vanishing`, `injective_acyclic ← injective_cech_acyclicFam` (the cover-agnostic form; blueprint allows this per the `% NOTE` at line 3698)
- **notes**: `\leanok` present; fully closed

### `\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh}` (chapter: `lem:affine_cech_vanishing_qcoh`, line 6046)
- **Lean target exists**: **NO** — `AlgebraicGeometry.affine_cech_vanishing_qcoh` does not appear in the file. Closest existing declaration: `affine_cech_vanishing_qcoh_of_tildeVanishing` (file line 437), which proves the same conclusion under an explicit `htilde` hypothesis
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has NO `\leanok` (correct — the unconditional form is not yet closed). The `_of_tildeVanishing` reduction is faithful scaffolding: it IS the blueprint target modulo discharging `htilde`. The `\lean{}` pin is aspirational (the future name when `htilde` is proved). See "Red flags" section for the missing-declaration issue and Blueprint Adequacy for the under-specification of how to discharge `htilde`.

### `\lean{AlgebraicGeometry.affine_serre_vanishing}` (chapter: `lem:affine_serre_vanishing`, line 3209)
- **Lean target exists**: **NO** — `AlgebraicGeometry.affine_serre_vanishing` does not appear in the file. Closest: `affine_serre_vanishing_of_tildeVanishing` (file line 466)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Same situation as `affine_cech_vanishing_qcoh`. The reduction form takes `htilde` as hypothesis, then applies `cech_eq_cohomology_of_basis (affineCoverSystem R)` at `⊤` (the whole affine), which is correct assembly. Not a fake — it's the blueprint target minus `htilde`.

---

## Red flags

### Placeholder / suspect bodies
None. Every declaration in the file has a fully-elaborated proof body. No `:= sorry`, no `:= True`, no `Classical.choice` on substantive claims.

### Excuse-comments
None. The docstrings honestly describe what is built and what remains (the `htilde` residual), but there are no "TODO: replace with real def" or "this is wrong but works" style comments.

### Axioms
None introduced.

---

## Unreferenced declarations (informational)

The following four declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Line | Assessment |
|---|---|---|
| `affine_cover_span_localizationAway` | 402 | **Substantive — should be blueprinted.** Proves that if `D(g_i)` cover `D(f)` in `Spec R`, then the images `g_i → R_f` span the unit ideal of `R_f`. This is the spanning hypothesis needed to apply `lem:cech_acyclic_affine` over `Spec R_f`. It is the key ingredient for the change-of-base step that the blueprint's proof of `lem:affine_cech_vanishing_qcoh` silently skips. |
| `cechCohomology_isZero_of_iso` | 422 | **Useful transport lemma — worth a brief blueprint block.** Packages the naturality "an iso `F ≅ G` transports Čech-vanishing from `F` to `G`", which the blueprint mentions in prose ("transporting along the isomorphism") but never names as a reusable helper. |
| `affine_cech_vanishing_qcoh_of_tildeVanishing` | 437 | **Substantive reduction — should be blueprinted.** This is the CURRENT formalization state of `lem:affine_cech_vanishing_qcoh`. The blueprint should document it as the conditional form pending `htilde`, so future iterations can clearly see what remains. |
| `affine_serre_vanishing_of_tildeVanishing` | 466 | **Substantive reduction — should be blueprinted.** Same as above for `lem:affine_serre_vanishing`. Documenting the Lane-1 assembly end-to-end in the blueprint would make the single remaining obligation (`htilde`) explicit. |

---

## Blueprint adequacy for this file

### Coverage
- 8/10 principal `\lean{...}` targets have closed Lean declarations in this file.
- 2 targets (`affine_serre_vanishing`, `affine_cech_vanishing_qcoh`) have no Lean declaration yet (intentionally — they await `htilde`).
- 4 substantive Lean declarations are unreferenced in the blueprint (see table above); 2 are critical helpers, 2 are the current reduction forms.

### Proof-sketch depth: **under-specified** on the critical path

The `lem:affine_cech_vanishing_qcoh` proof in the blueprint (lines 6064–6074) says:

> "The standard-cover Čech vanishing of Lemma cech_acyclic_affine applies to the tilde sheaf ~M: its section Čech complex over **any standard cover** is exact in positive degrees."

This is **incorrect as written**. `lem:cech_acyclic_affine` (`sectionCech_affine_vanishing`) is stated with `Ideal.span(range s) = ⊤`, meaning the spanning family covers the **whole** `Spec R`. The `affineCoverSystem.Cov` includes standard covers of **any** distinguished open `D(f)`, not only `D(1) = Spec R`. For a proper distinguished open `D(f)` (i.e. `f ≠ 1` in general), the cover family `g_i` does NOT span the unit ideal of `R`; it spans the unit ideal of `R_f`.

The change-of-base step that bridges these — (1) `D(g_i)` cover `D(f)` implies `(g_i mod R_f)` span `R_f`'s unit ideal (`affine_cover_span_localizationAway`), and (2) identify `~M` restricted to `D(f)` with `~(M_f)` over `Spec R_f` — is **entirely absent from the blueprint**. A prover following the blueprint's proof sketch for `lem:affine_cech_vanishing_qcoh` would not know to introduce `affine_cover_span_localizationAway` or to work over `Spec R_f`.

This is what the `htilde` hypothesis isolates in the Lean reductions: the tilde Čech vanishing for covers of proper `D(f)` is the non-trivial residual leaf. The blueprint neither names it nor describes how to prove it.

### Hint precision: **loose** on the two unfinished targets
The `\lean{}` pins `AlgebraicGeometry.affine_cech_vanishing_qcoh` and `AlgebraicGeometry.affine_serre_vanishing` are aspirational (correct future target names). Since neither has `\leanok`, the system correctly does not claim they are done. But the blueprint offers no alternative pin or `% NOTE:` acknowledging the `_of_tildeVanishing` intermediate state, which could mislead future prover dispatches into searching for declarations that don't exist.

### Generality: matches need
The file's declarations are at the right generality for what the cover system requires. No parallel API duplication.

### Recommended chapter-side actions

1. **Add a new blueprint lemma** for `affine_cover_span_localizationAway` (or an inline remark in `lem:affine_cech_vanishing_qcoh`'s proof sketch), describing the change-of-base step: "If `D(g_i)` cover `D(f)` in `Spec R`, then the images `g_i → R_f` span the unit ideal of `R_f` (the pull-back of the union `⊔ D(g_i)` to `Spec R_f` is all of `Spec R_f`)."

2. **Add a `% NOTE:` annotation** to both `lem:affine_cech_vanishing_qcoh` and `lem:affine_serre_vanishing` documenting that the current Lean state is the `_of_tildeVanishing` conditional form, with `htilde` (tilde Čech vanishing over standard covers of a proper `D(f)`) as the residual obligation. The note should name `affine_cech_vanishing_qcoh_of_tildeVanishing` and `affine_serre_vanishing_of_tildeVanishing` explicitly.

3. **Expand `lem:affine_cech_vanishing_qcoh`'s proof sketch** to describe the `htilde` discharge: (a) use `affine_cover_span_localizationAway` to obtain the spanning condition over `R_f`; (b) apply `lem:cech_acyclic_affine` over `Spec R_f` (since `D(f) ≅ Spec R_f`); (c) transport the vanishing from `~M` over `Spec R_f` back to `~M` over `D(f) ↪ Spec R`. Without this, the blueprint proof sketch is misleading.

4. **Add a brief blueprint block** for `cechCohomology_isZero_of_iso` (or note it inline in the proof), since the transport step "an iso `F ≅ G` induces an iso of Čech complexes" is a reusable fact that the blueprint's prose references but never crystallizes.

5. **Add `\leanok` to** `lem:toSheaf_preservesFiniteColimits` and `lem:to_sheaf_preserves_epi` (both have closed Lean proofs); the `sync_leanok` phase should handle this automatically.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{affine_serre_vanishing}` pins a nonexistent declaration; no `_of_tildeVanishing` mention in blueprint | **major** |
| `\lean{affine_cech_vanishing_qcoh}` same | **major** |
| Blueprint proof of `lem:affine_cech_vanishing_qcoh` is under-specified: silently skips the change-of-base to `R_f` step that the Lean prover had to discover independently; `affine_cover_span_localizationAway` (the spanning helper) is absent from the blueprint | **must-fix-this-iter** (blueprint adequacy failure — chapter is so under-specified on the htilde leaf that a prover cannot formalize the discharge from prose alone) |
| Four substantive unreferenced Lean declarations not documented in blueprint | **major** (2 reductions) / **minor** (2 helpers) |
| `lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi` missing `\leanok` despite closed proofs | **minor** (sync_leanok will fix) |

**Overall verdict:** The Lane-1 assembly infrastructure (cover system, acyclicity fields, section surjectivity, reduction lemmas) is cleanly formalized with no red flags, but the blueprint has a must-fix adequacy failure: the proof sketch for `lem:affine_cech_vanishing_qcoh` silently omits the change-of-base-to-`R_f` step that is the only remaining obstacle (`htilde`), making the blueprint unable to guide a prover past the current frontier without independent mathematical discovery.
