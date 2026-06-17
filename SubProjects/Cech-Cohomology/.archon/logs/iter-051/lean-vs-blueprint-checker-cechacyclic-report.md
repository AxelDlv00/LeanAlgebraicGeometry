# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
051

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (1895 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (7457 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway}` (chapter: `lem:affine_cech_vanishing_tilde_subcover`, blueprint line 6189–6215)

- **Lean target exists**: yes — `theorem sectionCech_homology_exact_of_localizationAway` at line 1868.
- **Signature matches**: yes.
  - Blueprint: ring `R`, module `M`, finite family `g : ι → R`, element `f ∈ R`, coverage
    `D(f) = ⊔ᵢ D(gᵢ)`, `p > 0` → `Ȟᵖ({D(gᵢ)}, ~M) = 0`.
  - Lean: `{R : CommRingCat.{u}} (M : ModuleCat.{u} R) {ι : Type u} [Finite ι] (s : ι → R) (f : R)`
    with `hcov : basicOpen f = ⨆ i, basicOpen (s i)`, `(p : ℕ) (hp : 1 ≤ p)`, conclusion
    `IsZero ((sectionCechComplex (fun i => basicOpen (s i)) (tilde M)).homology p)`.  
    All types match.
- **Proof follows sketch**: yes (substantively faithful, with additional infrastructure).
  - Blueprint says: (1) instantiate `dDiff_exact` over `R_f` where `{gᵢ/1}` spans; (2) degreewise
    transfer via `lem:away_comparison_isLocalizedModule` isomorphisms; (3) wrap as vanishing
    homology as in `lem:section_cech_homology_exact`.
  - Lean proof body: derives `hmem` (each `sᵢ ∈ √(f)`) and `hspan` (spanning in `R_f`) from
    `hcov`, then calls `sectionCechAbExact_loc` which chains
    `dDiff_exact_of_localizationAway` → tilde-bridge ladder → `sectionCech_isZero_homology_of_objD_exact`.
    Mathematical content matches all three blueprint steps.
- **Sorry-free**: yes — `lean_verify` returned `{"axioms":[], "warnings":[...]}` (warnings are
  intentional `opaque` uses; see Red Flags section).
- **notes**: Blueprint `lem:affine_cech_vanishing_tilde_subcover` has no `\leanok` yet (neither
  statement nor proof block); the `sync_leanok` phase should add it after this verification.

---

### `\lean{AlgebraicGeometry.AwayComparison.comparison_isLocalizedModule}` (chapter: `lem:away_comparison_isLocalizedModule`, blueprint line 6169–6186)

- **Lean target exists**: yes — `lemma comparison_isLocalizedModule` at line 608.
- **Signature matches**: yes. Blueprint: "the comparison `M_a → M_{ab}` exhibits `M_{ab}` as `M_a`
  localised at `b`." Lean: `IsLocalizedModule (Submonoid.powers b) (comparison fa fb hb)` given
  `IsLocalizedModule (powers (a*b)) fb`. Match.
- **Proof follows sketch**: N/A — no proof body in the blueprint block.
- **notes**: This pin resolves correctly. But the `\lean{}` bundle omits the sibling lemma
  `AwayComparison.isLocalizedModule_comp_away` (line 875), which is the distinct "double
  localisation" fact actually consumed by the route-B proof. See Blueprint→Lean gap #1 below.

---

### `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact}` (chapter: `lem:section_cech_module_exact`, blueprint line 1140–1175)

- **Lean target exists**: yes — `lemma dDiff_exact` at line 1177 (under `SectionCechModule`).
- **Signature matches**: yes. Blueprint: positive-degree `Function.Exact (d^{p+1}, d^{p+2})` for
  the un-localised module complex `D•`. Lean: `Function.Exact (dDiff s M (m + 1)) (dDiff s M (m + 2))`
  for `Ideal.span (Set.range s) = ⊤`. Match.
- **Proof follows sketch**: yes — matches the local-to-global reduction via
  `exact_of_isLocalized_span` + `map_dDiff_eq_locDiff` + `locDiff_exact` chain described in
  blueprint lines 1158–1174.
- **notes**: This lemma has `\leanok` on its proof block (blueprint line 1157). The sibling
  `dDiff_exact_of_localizationAway` is NOT in this bundle (see Blueprint→Lean gap #2).

---

## Red flags

### Intentional opaque uses (NOT red flags — informational only)

- **`spanIdx` (line 1161–1164)**: `private noncomputable def spanIdx := ρ.2.choose`. This is
  `Classical.choose` on a non-trivial claim, but it is marked `private` and its sole purpose is
  motive opacity for a `rw` in `dDiff_exact`. The docstring says "kept opaque so the
  spanning-element rewrite has a type-correct motive". The `lean_verify` warning at line 1161
  is expected and benign.
- **`set g` at line 1596**: An opaque local definition via `set` tactic to prevent
  heartbeat-heavy `whnf` inside an `IsLocalizedModule.ext` call. Comment explains this is
  intentional. The `lean_verify` warning at line 1593 is benign.

### Known sorry (pre-existing, not a new red flag)

- **`CechAcyclic.affine` body, line 110**: `sorry`. This is the top-level `CechAcyclic.affine`
  theorem (the P3 lane target), which the Lean file's own docstring (lines 18–20 and 80–110)
  explicitly marks as work-in-progress with a detailed reduction roadmap. This is NOT among the
  declarations being checked in this iteration; it is a tracked planned sorry for a future prover
  lane and does NOT affect the newly proved declarations above.

---

## Unreferenced declarations (informational)

The following substantive declarations in the Lean file have no `\lean{}` pin in any blueprint block:

| Declaration | Line | Status |
|---|---|---|
| `AwayComparison.isLocalizedModule_comp_away` | 875 | **public lemma**, no pin — see Blueprint→Lean gap #1 |
| `SectionCechModule.dDiff_exact_of_localizationAway` | 1217 | **public lemma**, no pin — see Blueprint→Lean gap #2 |
| `sectionCechAbExact_loc` | 1802 | private helper, acceptable |
| `SectionCechModule.cechCofaceLin` | 1072 | internal assembly helper |
| `SectionCechModule.locDiff` | 1086 | internal assembly helper |
| `SectionCechModule.fLoc` | 1118 | internal assembly helper |
| `SectionCechModule.map_dDiff_eq_locDiff` | 1151 | internal bridge, covered informally in `lem:section_cech_module_exact` proof |
| `SectionCechModule.dToCech_comm` | 1053 | internal bridge helper |
| `sectionCechAbExact` | 1775 | private, covered by `sectionCech_homology_exact` |

The `CechLocalized` and `AwayComparison` namespace helpers (lines 478–668, 679–858) all belong to the `\lean{}` bundle of `lem:section_cech_homology_exact` (blueprint line 644–666) and are correctly pinned there.

---

## Blueprint adequacy for this file

- **Coverage**: Of the two new public theorems added this iteration
  (`isLocalizedModule_comp_away`, `dDiff_exact_of_localizationAway`), neither is `\lean{}`-pinned.
  The top-level theorem (`sectionCech_homology_exact_of_localizationAway`) IS pinned. Ratio: 1/3
  new public theorems covered.
  
- **Proof-sketch depth**: **under-specified** for the route-B change-of-ring step.
  - `lem:affine_cech_vanishing_tilde_subcover`'s proof block (lines 6225–6269) says "instantiate
    that lemma over `R_f`" — treating the whole change-of-ring transport as a one-line reuse of
    `dDiff_exact`. In reality this required:
    (a) A new 80-line lemma `isLocalizedModule_comp_away` establishing that the two-step
        `M → M_f → (M_f)_{gσ}` presents `M` localised at `gσ` (given `f ∣ gσⁿ`);
    (b) A new ~120-line proof `dDiff_exact_of_localizationAway` that sets up `Rf`, `Mf`, `g'`,
        constructs the per-σ composite localisation instances via (a), builds the degreewise
        linear equivalences `eσL`, proves the two-sided naturality `nat`, assembles the ladder
        `E`, and calls `Function.Exact.of_ladder_addEquiv_of_exact`.
  - The blueprint gives zero preview of steps (a) or (b). A prover reading only the blueprint
    would not know these lemmas were needed or how to build them.
    
- **Hint precision**: **loose** for `lem:away_comparison_isLocalizedModule`.
  - The block (line 6171) pins `comparison_isLocalizedModule` (`M_a → M_{ab}` is localisation
    at `b`), but the Lean file's section docstring (lines 861–868) explicitly says
    `lem:away_comparison_isLocalizedModule` covers `isLocalizedModule_comp_away` (the two-step
    composite localisation). The two lemmas are mathematically related but distinct: one takes
    `M → M_a → M_{ab}` (same `M`), the other takes `M → M_f →^{Rf} N` (base-change).
    The `\lean{}` pin resolves to the wrong lemma for the route-B use case.

- **Generality**: **too narrow** for the route-B change-of-ring.
  - `lem:section_cech_module_exact` was written for the unit-ideal case (`Ideal.span = ⊤`).
    The subcover case needed a separate lemma `dDiff_exact_of_localizationAway` with a more
    complex hypothesis (`f ∣ sᵢⁿ` + spanning only in `R_f`). The blueprint has no block for
    this generalization.

- **Recommended chapter-side actions**:
  1. Add a new blueprint lemma block `lem:isLocalizedModule_comp_away` (or rename/expand
     `lem:away_comparison_isLocalizedModule`) with `\lean{AlgebraicGeometry.AwayComparison.isLocalizedModule_comp_away}` and a proof sketch: "The composite `gN.restrictScalars R ∘ mkf` is a localisation at `powers a` because: map_units follows from the `Rf`-module instance on N; surjectivity uses `a^{j*l+k}` from `a^j = f*h`; exists_of_eq uses the two-step kernel extraction."
  2. Add a new blueprint lemma block `lem:section_cech_module_exact_of_localizationAway` (or a remark under `lem:section_cech_module_exact`) with `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact_of_localizationAway}` and a proof sketch covering the `Rf`/`Mf`/`g'` instantiation, the per-σ composite instances, the `eσL` equivalences, naturality, and the ladder.
  3. The proof block of `lem:affine_cech_vanishing_tilde_subcover` should `\uses` both new blocks and expand its "Degreewise transfer" paragraph to name `isLocalizedModule_comp_away` explicitly and outline the ladder structure.
  4. Add `\leanok` to `lem:away_comparison_isLocalizedModule` statement and proof (the pinned `comparison_isLocalizedModule` is sorry-free) after the next `sync_leanok` pass.
  5. Add `\leanok` to `lem:affine_cech_vanishing_tilde_subcover` statement and proof (the pinned `sectionCech_homology_exact_of_localizationAway` is sorry-free per `lean_verify`).

---

## Severity summary

| Finding | Severity |
|---|---|
| **Blueprint→Lean gap**: `AwayComparison.isLocalizedModule_comp_away` (public, substantive, ~80 lines) has no `\lean{}` pin; `lem:away_comparison_isLocalizedModule` pins a different (related) lemma | **major** |
| **Blueprint→Lean gap**: `SectionCechModule.dDiff_exact_of_localizationAway` (public, substantive, ~120 lines) has no `\lean{}` pin; the route-B step in `lem:affine_cech_vanishing_tilde_subcover`'s proof block treats it as a one-liner | **major** |
| **Blueprint adequacy**: proof block for `lem:affine_cech_vanishing_tilde_subcover` under-specifies the change-of-ring step by ~200 lines of formalization (no preview of the composite-localisation or ladder infrastructure) | **major** |
| `lem:away_comparison_isLocalizedModule` `\lean{}` hint precision: pins `comparison_isLocalizedModule` but the Lean section docstring says this label covers `isLocalizedModule_comp_away`; the Lean prover who read only the blueprint would target the wrong declaration | **major** |
| Missing `\leanok` on `lem:away_comparison_isLocalizedModule` (both pinned lemma and proof are sorry-free) | **minor** (pending next `sync_leanok`) |
| Missing `\leanok` on `lem:affine_cech_vanishing_tilde_subcover` | **minor** (pending next `sync_leanok`) |

**Overall verdict**: `sectionCech_homology_exact_of_localizationAway` is correctly stated, sorry-free, and proof-faithful to the blueprint route; however, two of the three substantive new public lemmas introduced to support it have no blueprint coverage, and the blueprint's proof sketch under-specifies the change-of-ring step by a wide margin — four major blueprint→Lean gaps that the planner should address next iteration.
