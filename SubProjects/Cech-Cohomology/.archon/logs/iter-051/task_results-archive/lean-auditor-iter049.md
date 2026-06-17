# Lean Audit Report

## Slug
iter049

## Iteration
049

## Scope
- files audited: 1 (directive-specified scope)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor — large heartbeat overrides)
- **excuse-comments**: none
- **notes**:
  - **Line 30 — `attribute [local instance] hasExtModules`:** Benign. `hasExtModules` is confirmed as `noncomputable local instance hasExtModules : HasExt.{u+1,u,u+1} X.Modules := HasExt.standard _` in `AbsoluteCohomology.lean` (line 25 there). Reactivating it as a file-local instance in this file is a standard Lean performance pattern (the comment gives the correct reason: avoids the slow `HasSmallLocalizedHom` path). No soundness issue.
  - **Line 46 — `affine_faces_mem`:** Signature and body are consistent. Correctly packages the `basicOpen_sprod` identity in the `Set.range`-membership shape. No issues.
  - **Lines 58–67 — `coverOpen_affineOpenCoverOfSpan`:** Proof uses `change` + `ext` + `rw [Spec.map_base]` + `PrimeSpectrum.localization_away_comap_range`. The `ext` here is on `Opens` (comparing as sets via `TopologicalSpace.Opens.ext`), which is a standard structural ext; no subsingleton-goal kernel trap. `change` unfolds the definitional equality of `coverOpen` — benign.
  - **Lines 79–90 — `affine_injective_acyclic`:** Clean reduction via `cechCohomology`/`hbridge` funext rewrite, then `injective_cech_acyclic`. No issues.
  - **Lines 119–144 — `toSheaf_preservesFiniteColimits`:** Complex but structurally sound. The key step `asIso (sheafificationAdjunction).counit` is valid because the counit of the sheafification adjunction is an isomorphism (reflective localization); if it were not Lean would reject the `asIso`. The `preservesColimit_of_iso_diagram` at line 144 transfers the preservation along `e.symm : D ⋙ sheafification ≅ F`. Universe annotations are explicit and consistent. Zero sorrys.
  - **Lines 220, 363 — `set_option maxHeartbeats 1600000/2000000`:** Both large heartbeat ceilings flag slow proofs (`affine_surj_of_vanishing` and `affineCoverSystem`). Not a soundness issue but worth noting — the proofs are elaborate and these ceilings suppress timeout errors.
  - **Lines 402–413 — `affine_cover_span_localizationAway`:** See detailed analysis below.
  - **Lines 422–426 — `cechCohomology_isZero_of_iso`:** See detailed analysis below.
  - **Lines 437–453 — `affine_cech_vanishing_qcoh_of_tildeVanishing`:** See detailed analysis below.
  - **Lines 466–480 — `affine_serre_vanishing_of_tildeVanishing`:** See detailed analysis below.

---

## Detailed analysis of the four focus declarations

### `affine_cover_span_localizationAway` (lines 402–413)

**Signature:** Given `g : ι → R`, `f : R`, and a covering hypothesis `hcov : basicOpen f = ⨆ i, basicOpen (g i)`, conclude that the images `algebraMap R (Localization.Away f) (g i)` span `⊤` in `R_f`. Mathematically correct statement.

**Proof trace (simp/rw/comap_basicOpen chain):**

| Step | Lemma | Effect |
|------|-------|--------|
| `rw [← PrimeSpectrum.iSup_basicOpen_eq_top_iff]` | Rewrites span-top to iSup-of-basicOpens-is-top | Goal: `⨆ i, basicOpen (algebraMap ... (g i)) = ⊤` |
| `simp only [← PrimeSpectrum.comap_basicOpen]` | Pulls map out of basicOpen | Goal: `⨆ i, comap φ (basicOpen (g i)) = ⊤` |
| `rw [← map_iSup]` | Preimage distributes over iSup (comap is a frame homomorphism) | Goal: `comap φ (⨆ i, basicOpen (g i)) = ⊤` |
| `rw [← hcov]` | Uses the covering hypothesis | Goal: `comap φ (basicOpen f) = ⊤` |
| `rw [PrimeSpectrum.comap_basicOpen]` | Rewrites comap of basicOpen | Goal: `basicOpen (algebraMap R R_f f) = ⊤` |
| `rw [eq_top_iff]` | Converts to `⊤ ≤ basicOpen (...)` | Goal: `∀ p : Spec R_f, p ∈ basicOpen (φ f)` |
| `rintro p -` + `rw [PrimeSpectrum.mem_basicOpen]` | Unfolds membership | Goal: `φ f ∉ p.asIdeal` |
| `exact fun hmem => p.isPrime.ne_top (Ideal.eq_top_of_isUnit_mem _ hmem (IsLocalization.Away.algebraMap_isUnit f))` | `f` maps to a unit in `R_f`, so it cannot lie in any prime | QED |

Each step is mathematically justified. The last step is the core: `IsLocalization.Away.algebraMap_isUnit f` asserts `algebraMap R R_f f` is a unit, so `Ideal.eq_top_of_isUnit_mem` + `p.isPrime.ne_top` closes the goal by contradiction. **No issues.**

### `cechCohomology_isZero_of_iso` (lines 422–426)

```lean
h.of_iso ((HomologicalComplex.homologyFunctor Ab p).mapIso
    ((sectionCechComplexFunctor U).mapIso e)).symm
```

Proof chains two functor applications:
1. `(sectionCechComplexFunctor U).mapIso e : sectionCechComplex U F ≅ sectionCechComplex U G`
2. `(homologyFunctor Ab p).mapIso ... : cechCohomology U F p ≅ cechCohomology U G p`
3. `.symm` reverses the iso direction so `h.of_iso` can transfer `IsZero` from F to G.

No `ext`/`congr 1` on subsingleton goals. `of_iso` is the standard `IsZero` transport. **Clean and correct.**

### `affine_cech_vanishing_qcoh_of_tildeVanishing` (lines 437–453)

**Is `htilde` a genuine unmet obligation — not vacuous, not a disguised sorry?**

Yes. The hypothesis asserts:

> For ALL covers `D(gᵢ)` of `D(f)` in `Spec R` (indexed by `ULift (Fin n)`), and ALL degrees `p > 0`, the Čech cohomology group `Ȟᵖ({D(gᵢ)}, ~(ΓF))` is zero.

This is:
- **Non-vacuous in domain:** The quantifier ranges over all finite covering families satisfying the spanning condition, not an empty type. Every affine has non-trivial covers.
- **Non-trivial in conclusion:** `IsZero (cechCohomology ...)` is a concrete assertion about an abelian group computed from a Čech complex of module sections. It can fail (e.g., for non-quasi-coherent sheaves or non-standard rings).
- **Actually used:** Line 453 `exact htilde n g f hcov p hp` applies the hypothesis with concrete values `n`, `g`, `f`, `hcov`, `p`, `hp` extracted from the covering datum. The hypothesis is not merely stated — it is discharged against concrete instances.
- **No sorry or axiom substitute:** `sorry_count = 0` in the file.

**Proof structure:** `intro c hc p hp` → `obtain ⟨n, g, f, rfl, hcov⟩ := hc` destructs the covering datum → `cechCohomology_isZero_of_iso` reduces from `F` to `~(ΓF)` using `qcoh_iso_tilde_sections F` (which is non-sorry in `QcohTildeSections.lean`) → `htilde` closes the tilde case. The overall argument is sound and the `IsQuasicoherent` hypothesis is essential (it is what makes `qcoh_iso_tilde_sections` applicable).

### `affine_serre_vanishing_of_tildeVanishing` (lines 466–480)

**Is `htilde` a genuine unmet obligation?** Yes, same `htilde` as above (identical type). See analysis above.

**Non-vacuously true?** The conclusion is `e = 0` for `e : Ext^p(j_! O_⊤, F)` with `p > 0` — the Serre vanishing theorem for affines. This is a highly non-trivial statement that requires the full machine of `cech_eq_cohomology_of_basis`. The hypotheses `[EnoughInjectives (Spec R).Modules]` and `F.IsQuasicoherent` are both genuinely necessary (without injectives, the derived functor Ext is not defined; without quasicoherence, the affine structure theorem fails).

**Proof:** One-liner via `cech_eq_cohomology_of_basis (affineCoverSystem R) (affine_cech_vanishing_qcoh_of_tildeVanishing F htilde) ⊤ ⟨1, PrimeSpectrum.basicOpen_one⟩ p hp e`. This is the correct instantiation: `⊤ = D(1)` is the witness that `⊤ ∈ B`, and `affine_cech_vanishing_qcoh_of_tildeVanishing F htilde` discharges the vanishing field of the cover system. **Sound.**

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `AffineSerreVanishing.lean:220` — `set_option maxHeartbeats 1600000` on `affine_surj_of_vanishing`. Suggests the proof is slow; not unsound, but a candidate for eventual optimization.
- `AffineSerreVanishing.lean:363` — `set_option maxHeartbeats 2000000` on `affineCoverSystem`. Same observation.

---

## Excuse-comments (always called out separately)

None. The file contains no excuse-comments of the form "TODO replace with real def", "placeholder", "temporary", "wrong but works", or "will fix later". The module-doc mention of "handed off to the assembly iteration" at line 18 is accurate and descriptive (it correctly says these declarations are handled elsewhere), not an excuse.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 2 (both are performance notes, no correctness concern)
- **excuse-comments**: 0

**Overall verdict:** `AffineSerreVanishing.lean` is axiom-free (0 sorrys confirmed), all four new declarations are mathematically sound and non-vacuous, `htilde` is a genuine residual obligation threaded as an explicit argument, and `attribute [local instance] hasExtModules` is a benign file-local performance optimization with no soundness implication.
