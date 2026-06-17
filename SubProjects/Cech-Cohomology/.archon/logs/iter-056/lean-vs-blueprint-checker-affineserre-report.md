# Lean ↔ Blueprint Check Report

## Slug
affineserre

## Iteration
056

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### Pre-existing declarations (iters prior to 056)

These 15 declarations all have matching `\lean{...}` references in the blueprint and were verified
in prior iters. No new issues found on re-audit.

| Declaration | Blueprint ref | Signature match | Proof match | Notes |
|---|---|---|---|---|
| `affine_faces_mem` | `\lean{AlgebraicGeometry.affine_faces_mem}` | yes | yes | `\leanok` in blueprint |
| `coverOpen_affineOpenCoverOfSpan` | `\lean{AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan}` | yes | yes | `\leanok` |
| `affine_injective_acyclic` | `\lean{AlgebraicGeometry.affine_injective_acyclic}` | yes | yes | `\leanok` |
| `toSheaf_preservesFiniteColimits` | `\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}` | yes | yes | universe-polymorphic form matches |
| `toSheaf_preservesEpimorphisms` | `\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}` | yes | yes | corollary of above |
| `standard_cover_cofinal` | `\lean{AlgebraicGeometry.standard_cover_cofinal}` | yes | yes | `\leanok` |
| `affine_surj_of_vanishing` | `\lean{AlgebraicGeometry.affine_surj_of_vanishing}` | yes | yes | `\leanok` |
| `affineCoverSystem` | `\lean{AlgebraicGeometry.affineCoverSystem}` | yes | yes | `\leanok` |
| `affine_cover_span_localizationAway` | `\lean{AlgebraicGeometry.affine_cover_span_localizationAway}` | yes | yes | — |
| `cechCohomology_isZero_of_iso` | `\lean{AlgebraicGeometry.cechCohomology_isZero_of_iso}` | yes | yes | — |
| `affine_cech_vanishing_qcoh_of_tildeVanishing` | compound `\lean{...}` block | yes | yes | — |
| `affine_serre_vanishing_of_tildeVanishing` | compound `\lean{...}` block | yes | yes | — |
| `affine_tildeVanishing` | `\lean{AlgebraicGeometry.affine_tildeVanishing}` | yes | yes | declared `private`; see Red Flags |
| `affine_cech_vanishing_qcoh` | `\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh}` | yes | yes | — |
| `affine_serre_vanishing` | `\lean{AlgebraicGeometry.affine_serre_vanishing}` | yes | yes | `\leanok` |

---

### `\lean{AlgebraicGeometry.affine_serre_vanishing_general_open_TODO}` (chapter: `\lem:affine_serre_vanishing_general_open`)

- **Lean target exists**: **no**. A declaration named `affine_serre_vanishing_general_open_TODO` does
  not appear anywhere in the Lean file. The blueprint NOTE at line 8313 acknowledges this is a
  placeholder: *"The Lean declaration does not exist yet."*
- **Signature matches**: N/A (declaration absent). Nearest Lean target is
  `affine_serre_vanishing_general_of_tildeVanishing`, which has the same conclusion
  (`Ext^p(jShriekOU V, F) = 0` for any affine open `V`, quasi-coherent `F`, `p > 0`) but carries
  `htilde` as an **explicit hypothesis**, making it a conditional form rather than the unconditional
  statement the blueprint asserts.
- **Proof follows sketch**: partial. The blueprint proof sketch (lines 8330–8360) correctly describes
  the three cover-system fields and mentions the seed. The Lean file implements all three fields via
  `isAffineOpen_specBasicOpen`, `standard_cover_cofinal_affine`, and
  `affine_surj_of_vanishing_affine`, assembled into `affineCoverSystemGeneral`. The seed step is
  represented by `affine_cech_vanishing_qcoh_general_of_tildeVanishing`, which isolates the
  change-of-scheme leaf as `htilde`. The blueprint proof sketch says "condition (3) holds by the
  same quasi-coherent seed as in Lemma~\ref{lem:affine_serre_vanishing}" (lines 8354–8356); the
  Lean code correctly identifies that the seed is **not** proved by the same argument as the
  distinguished case — it requires a change-of-scheme identification (via `Γ(V)`) rather than a
  change-of-ring (`R_f`), and thus remains as an explicit hypothesis `htilde`.
- **notes**: The seven iter-056 declarations collectively implement the infrastructure for
  `lem:affine_serre_vanishing_general_open` but leave the seed as a residual. The blueprint block
  has no `\leanok`.

---

### New iter-056 declarations — NOT referenced by any `\lean{...}` in the blueprint

The following 7 declarations were introduced this iteration and have **no** `\lean{...}` pointer in
the blueprint chapter. They are substantive (one `noncomputable def`, six `theorem`s), not
pure helpers.

#### `AlgebraicGeometry.isAffineOpen_specBasicOpen`
- Lean line 545–547. States: `IsAffineOpen (X := Spec R) (PrimeSpectrum.basicOpen r)`.
- Blueprint equivalent: described in the proof sketch of `lem:affine_serre_vanishing_general_open`
  ("`faces_mem`: the faces … are distinguished, hence affine") but not given its own lemma block.
- No sorry. Proof is a one-liner via `basicOpenIsoSpecAway`.

#### `AlgebraicGeometry.standard_cover_cofinal_affine`
- Lean lines 556–600. Generalises `standard_cover_cofinal` from `D(f)` to an arbitrary affine open
  `V`, using `IsAffineOpen.isCompact` in place of `PrimeSpectrum.isCompact_basicOpen`.
- Blueprint equivalent: described at lines 8346–8352 of the proof sketch: "a general affine open is
  quasi-compact … so the refinement of an arbitrary open cover of V to a finite standard cover goes
  through unchanged." No dedicated lemma block; `\uses` for `lem:affine_serre_vanishing_general_open`
  still points to `lem:standard_cover_cofinal` (the D(f) form), not a general-affine version.
- No sorry. Proof is a structural copy of `standard_cover_cofinal` with `isCompact` source swapped.

#### `AlgebraicGeometry.affine_surj_of_vanishing_affine`
- Lean lines 615–739. Generalises `affine_surj_of_vanishing` from a distinguished open to an
  arbitrary affine open `V₀`, using `standard_cover_cofinal_affine` and propagating the affineness
  hypothesis `IsAffineOpen V₀` into `hvanish`.
- Blueprint equivalent: `lem:affine_surj_of_vanishing` (lines 3393–3454) covers only the
  distinguished case. No separate blueprint block for the general-affine form. The `\uses` of
  `lem:affine_serre_vanishing_general_open` still references `lem:affine_surj_of_vanishing` (the
  old form), not the new generalisation.
- No sorry.

#### `AlgebraicGeometry.affineCoverSystemGeneral`
- Lean lines 755–776. `noncomputable def` of a `BasisCovSystem (Spec R)` with basis = all affine
  opens and coverings = standard finite covers whose union is affine.
- Blueprint equivalent: described in the proof sketch of `lem:affine_serre_vanishing_general_open`
  (lines 8334–8338: "Instantiate … with its basis B enlarged to all affine opens") but no
  `\lean{...}` block or `def:affine_cover_system_general` label exists.
- No sorry.

#### `AlgebraicGeometry.affine_cech_vanishing_qcoh_general_of_tildeVanishing`
- Lean lines 799–815. Reduces `HasVanishingHigherCech (affineCoverSystemGeneral R) F` to `htilde`
  via `qcoh_iso_tilde_sections` and `cechCohomology_isZero_of_iso`. Verbatim analogue of
  `affine_cech_vanishing_qcoh_of_tildeVanishing` for the enlarged system.
- Blueprint equivalent: the proof sketch mentions the reduction but no dedicated lemma block exists.
- No sorry.

#### `AlgebraicGeometry.affine_serre_vanishing_general_of_seed`
- Lean lines 824–829. Given `hseed : HasVanishingHigherCech (affineCoverSystemGeneral R) F` and an
  affine open `V`, proves `Ext^p(jShriekOU V, F) = 0` for `p > 0`.
- Blueprint equivalent: partial match to `lem:affine_serre_vanishing_general_open`, but that block
  is unconditional whereas this theorem carries `hseed` explicitly.
- No sorry.

#### `AlgebraicGeometry.affine_serre_vanishing_general_of_tildeVanishing`
- Lean lines 837–850. Composes the two preceding declarations; takes `htilde` as explicit hypothesis
  and gives `Ext^p(jShriekOU V, F) = 0` for any affine open `V`, `p > 0`.
- Blueprint equivalent: closest to `lem:affine_serre_vanishing_general_open`, but conditional on
  `htilde`. The unconditional form is the remaining gap.
- No sorry.

---

## Red Flags

### `affine_tildeVanishing` — `private` but blueprint-referenced

`affine_tildeVanishing` at Lean line 491 is declared `private`. The blueprint (line 6050) places it
inside a compound `\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh, ...,
AlgebraicGeometry.affine_tildeVanishing}` reference and the blueprint NOTE at line 6056 explicitly
labels it a "private helper". The `\lean{...}` link is therefore nominal (private declarations are
not publicly accessible) but the blueprint's intention is clear — this is not a bug, just a minor
tracking note.

---

## Unreferenced declarations (informational)

All 7 new iter-056 declarations are substantive and currently unreferenced by any `\lean{...}` in
the blueprint:

| Declaration | Nature | Should blueprint reference? |
|---|---|---|
| `isAffineOpen_specBasicOpen` | helper lemma | Yes — feeds `faces_mem` of enlarged cover system |
| `standard_cover_cofinal_affine` | key lemma | Yes — blueprint's \uses should list it |
| `affine_surj_of_vanishing_affine` | key lemma | Yes — generalises `lem:affine_surj_of_vanishing` |
| `affineCoverSystemGeneral` | **definition** | Yes — needs a `def:affine_cover_system_general` block |
| `affine_cech_vanishing_qcoh_general_of_tildeVanishing` | reduction lemma | Yes |
| `affine_serre_vanishing_general_of_seed` | top-level theorem | Yes |
| `affine_serre_vanishing_general_of_tildeVanishing` | top-level theorem | Yes — closest to `lem:affine_serre_vanishing_general_open` |

---

## Blueprint adequacy for this file

**Coverage**: 15/22 Lean declarations have a corresponding `\lean{...}` block. 7 substantive
declarations introduced this iteration have no blueprint reference. Coverage rate for iter-056 new
work: 0/7.

**Proof-sketch depth**: **under-specified** for the Need #2 declarations.

- The single block `lem:affine_serre_vanishing_general_open` (lines 8309–8360) describes the
  construction correctly in principle (three fields, and the seed) but does not decompose it into
  any of the 7 intermediate declarations the prover was required to build.
- The `\uses` clause still points to `lem:affine_surj_of_vanishing` (the distinguished-open form)
  and `lem:standard_cover_cofinal` (the distinguished-open form) rather than their general-affine
  generalisations, which is misleading: the generalisation is nontrivial and the blueprint implies
  the general form follows immediately from the distinguished form without new work.
- The proof sketch says "condition (3) holds by the same quasi-coherent seed as in
  Lemma~\ref{lem:affine_serre_vanishing}" (lines 8354–8356). This is **materially wrong**: the
  distinguished case discharges the seed by `sectionCech_homology_exact_of_localizationAway` via
  change-of-ring to `R_f` (a ring-theoretic localisation). The general-affine case needs a
  change-of-scheme to `Spec Γ(V)` — an entirely different proof route. The Lean file correctly
  isolates this as an unproved hypothesis `htilde`. The surrounding prose (lines 8119–8126) does
  hint at the change-of-scheme route, but the proof sketch for the lemma itself does not, leaving
  a prover who reads only the lemma block to expect the seed is already handled.

**Hint precision**: **wrong** for `lem:affine_serre_vanishing_general_open`. The `\lean{...}` hint
names `affine_serre_vanishing_general_open_TODO`, a declaration that does not exist. The blueprint
comment notes this is intentional ("placeholder until a prover lands it"), but the 7 actual
declarations introduced this iteration are not reflected in any `\lean{...}` hint.

**Generality**: The blueprint's `lem:affine_serre_vanishing_general_open` is stated correctly (any
affine open `V`, unconditional); the Lean file correctly decomposes this into a conditional form
(with `htilde` as residual) and the infrastructure. No generality mismatch. The `affineCoverSystemGeneral` definition is at the right level of generality.

**Residual `htilde`/`hseed` faithfulness**: The residuals are faithfully represented. The Lean
declarations `affine_serre_vanishing_general_of_tildeVanishing` and
`affine_serre_vanishing_general_of_seed` carry `htilde`/`hseed` as explicit hypotheses exactly
encoding the remaining gap: the positive-degree Čech vanishing of `~M` over a standard cover
whose union is a *general* affine open (not just a distinguished `D(f)`). This is precisely the
change-of-scheme leaf described in the surrounding blueprint prose (lines 8119–8126) under "(2c)".

**Recommended chapter-side actions**:

1. Add a `\lean{AlgebraicGeometry.isAffineOpen_specBasicOpen}` lemma block (helper: distinguished
   opens are affine) — 1 line.
2. Add a `\lean{AlgebraicGeometry.standard_cover_cofinal_affine}` lemma block generalising
   `lem:standard_cover_cofinal` to arbitrary affine opens; update `\uses` of
   `lem:affine_serre_vanishing_general_open` to reference it.
3. Add a `\lean{AlgebraicGeometry.affine_surj_of_vanishing_affine}` lemma block; update `\uses`.
4. Add a `def:affine_cover_system_general` definition block for `affineCoverSystemGeneral`.
5. Add lemma blocks for `affine_cech_vanishing_qcoh_general_of_tildeVanishing`,
   `affine_serre_vanishing_general_of_seed`, and `affine_serre_vanishing_general_of_tildeVanishing`.
6. Replace `\lean{AlgebraicGeometry.affine_serre_vanishing_general_open_TODO}` in
   `lem:affine_serre_vanishing_general_open` with the actual partial declaration name
   (currently `affine_serre_vanishing_general_of_tildeVanishing`) and add a `% NOTE` that
   `htilde` remains as the open leaf.
7. Correct the proof sketch to distinguish the general seed from the distinguished seed:
   "condition (3) requires a change-of-scheme to `Spec Γ(V)`, not the change-of-ring
   `sectionCech_homology_exact_of_localizationAway` used in the distinguished case."

---

## Severity summary

### Major findings

1. **7 unreferenced substantive declarations** — `isAffineOpen_specBasicOpen`,
   `standard_cover_cofinal_affine`, `affine_surj_of_vanishing_affine`, `affineCoverSystemGeneral`,
   `affine_cech_vanishing_qcoh_general_of_tildeVanishing`, `affine_serre_vanishing_general_of_seed`,
   `affine_serre_vanishing_general_of_tildeVanishing` all lack `\lean{...}` blueprint references.
   The blueprint's TODO placeholder name (`affine_serre_vanishing_general_open_TODO`) matches no
   Lean declaration. (Blueprint coverage failure: 0/7 new declarations referenced.)

2. **`\lean{...}` hint mismatch** — `lem:affine_serre_vanishing_general_open` points to
   `affine_serre_vanishing_general_open_TODO`, a non-existent declaration. The semantically nearest
   Lean declaration (`affine_serre_vanishing_general_of_tildeVanishing`) has an explicit `htilde`
   hypothesis that the blueprint's statement does not carry; the `\uses` clause references
   superseded forms.

3. **Blueprint under-specification of seed route** — The proof sketch for
   `lem:affine_serre_vanishing_general_open` claims the seed follows by "the same quasi-coherent
   seed as in Lemma~\ref{lem:affine_serre_vanishing}", which is mathematically incorrect: the
   general-affine case requires a change-of-scheme argument that is entirely absent from the
   distinguished-case discharge path. A prover reading only the lemma block would be misled about
   the difficulty of the residual.

### Minor findings

4. `affine_tildeVanishing` declared `private` while blueprint references it by qualified name
   (blueprint NOTE acknowledges this; cosmetic only).

---

**Overall verdict**: The iter-056 Lean code is mathematically clean and correct (7 new declarations, zero `sorry`, proofs close), but the blueprint has zero `\lean{...}` coverage of any of the 7 new declarations — 7 major coverage gaps and 1 major proof-sketch inaccuracy (seed route description) require blueprint-side follow-up before the chapter adequately documents the current Lean state.
