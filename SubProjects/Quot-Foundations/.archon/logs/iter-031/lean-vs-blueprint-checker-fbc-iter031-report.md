# Lean ↔ Blueprint Check Report

## Slug
fbc-iter031

## Iteration
031

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (2050 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (3332 lines)

---

## Per-declaration

Every `\lean{...}` block in the chapter was verified. The file has dense coverage; only blocks with notable findings are detailed. All others pass.

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (`def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — `g^*(f_*F) ⟶ f'_*(g')^*F` via adjunction transpose as stated
- **Proof follows sketch**: yes (definition, no sorry)
- **notes**: clean

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` — `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` — `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}`
- **Lean target exists**: yes (lines 102, 128, 164)
- **Signature matches**: yes (all three)
- **Proof follows sketch**: yes / yes / yes — all proved, no sorry
- **notes**: clean

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (`lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `(Spec φ)_*(M^~) ≅ tilde(restrictScalars φ M)`
- **Proof follows sketch**: yes — builds via `pushforward_spec_tilde_iso_of_isLocalizedModule` + basic-open route; axiom-clean
- **notes**: complex proof but well-documented; clean

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (`lem:base_change_mate_fstar_reindex_legs`)
- **Lean target exists**: yes (line 1381), **sorry at line 1472**
- **Signature matches**: yes — leg-parametrised form, uses `base_change_mate_codomain_read_legs`, conclusion is `= base_change_mate_inner_value`
- **Proof follows sketch**: partial — steps (i) `subst`, (ii) `simp only` collapse, start of (iii) `distributeCollapse` splice are landed; the residual eCancel telescoping is `sorry`
- **notes**: DECLARATION-ORDERING PROBLEM (see Red Flags). Iter-031 advance confirmed: `simp only [base_change_mate_codomain_read_legs, Iso.trans_hom, …]` at line 1451 is new and correctly exposed. The `congrArg (fun z => _ ≫ (z ≫ _) ≫ _) (…link_distributeCollapse…).trans ?_` splice is in place.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}` (`lem:…_link_distributeCollapse`)
- **Lean target exists**: yes (line 1333)
- **Signature matches**: yes — fuses (iii-L1)+(iii-L2) into one clean three-factor output; `\leanok` in blueprint
- **Proof follows sketch**: yes — proved, no sorry
- **notes**: L1 link resolved (iter-031)

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelEUnit}` (`lem:…_link_cancelEUnit`)
- **Lean target exists**: **no** — declaration absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: DANGLING PIN. Blueprint pin names `AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelEUnit` (L3); declaration does not exist in Lean. No `\leanok` in blueprint (correct). This is an unformalized blueprint step.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelPullbackComp}` (`lem:…_link_cancelPullbackComp`)
- **Lean target exists**: **no** — declaration absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: DANGLING PIN. Same as above for L4. No `\leanok` in blueprint (correct).

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_survivor}` (`lem:…_link_survivor`)
- **Lean target exists**: **no** — declaration absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: DANGLING PIN. Same as above for L5. No `\leanok` in blueprint (correct).

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` — `…_pushforwardComp` — `…_pullbackComp`
- **Lean target exists**: yes (lines 1549, 1561, 1578)
- **Signature matches**: yes — all three match the blueprint (A-2a, A-2b, A-2c)
- **Proof follows sketch**: yes — all proved, no sorry
- **notes**: DECLARATION-ORDERING PROBLEM (see Red Flags). These are proved and correct, but appear AFTER `base_change_mate_fstar_reindex_legs` in the file; they cannot be referenced in the `_legs` sorry block.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (`lem:base_change_mate_inner_value_eq`)
- **Lean target exists**: yes (line 1635)
- **Signature matches**: yes — same statement as `base_change_mate_fstar_reindex`
- **Proof follows sketch**: yes — one-liner `exact base_change_mate_fstar_reindex ψ φ M`, no sorry inline
- **notes**: Transitively sorry-backed through `_legs`. Blueprint and Lean agree on the cascade route.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (`lem:base_change_mate_gstar_counit_transport`)
- **Lean target exists**: yes (line 1673)
- **Signature matches**: yes — counit-transport identity as stated in blueprint
- **Proof follows sketch**: yes — proved, no sorry
- **notes**: clean; counit dual of Seam 1

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (`lem:base_change_mate_gstar_transpose`)
- **Lean target exists**: yes (line 1721), **sorry at line 1844**
- **Signature matches**: yes
- **Proof follows sketch**: partial — conjugate-counit scaffold landed (iter-022); crux is inner-value identification + generator close
- **notes**: Known gated sorry. Blueprint's four-move proof recipe is detailed and adequate. The inner-value step currently cites `base_change_mate_fstar_reindex` (which is sorry-backed via `_legs`).

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (`lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 1994), **sorry at line 2025**
- **Signature matches**: yes — `IsPullback g' f' f g → [IsAffineHom f] → IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: partial — locality reduction `base_change_map_affine_local` is applied; affine-reduction step (chart restriction) is `sorry`
- **notes**: Known gated sorry (affine). Blueprint adequately describes the remaining obligation (affine-chart restriction, naturality of transpose + pushforward-commutes-with-restriction).

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (`FBC-B`)
- **Lean target exists**: yes (line 2034), **sorry at line 2047**
- **Signature matches**: yes — `[Flat g] → [QuasiCompact f] → [QuasiSeparated f] → IsIso`
- **notes**: Known gated sorry (Čech complex infrastructure). Blueprint describes the Stacks 02KH strategy.

---

## Red Flags

### Placeholder / suspect bodies

- **`base_change_mate_fstar_reindex_legs` at line 1472**: `:= sorry` on a substantive theorem the blueprint claims is closeable via the four clean-term links. However, step (iii) eCancel residual is acknowledged in comments; **not a fake placeholder** — the sorry is a known open crux. The iter-031 advance (simp only before sorry) is genuine progress.
- **`base_change_mate_gstar_transpose` at line 1844**: `:= sorry` on Seam 3. Known, gated.
- **`affineBaseChange_pushforward_iso` at line 2025**: `:= sorry` on affine reduction. Known, gated.
- **`flatBaseChange_pushforward_isIso` at line 2047**: `:= sorry` on FBC-B. Known, gated.

### Declaration Ordering — BLOCKS CLOSING THE `_legs` SORRY (major)

The three eCancel atoms are defined **after** `base_change_mate_fstar_reindex_legs` in the Lean file:

| Declaration | Lean line | Needed by |
|---|---|---|
| `base_change_mate_fstar_reindex_legs` (sorry) | 1381–1472 | — (the target) |
| `base_change_mate_inner_eCancel_eUnit` | 1549 | `_legs` step (iii) cancellation 1 |
| `base_change_mate_inner_eCancel_pushforwardComp` | 1561 | `_legs` step (iii) cancellation 2 |
| `base_change_mate_inner_eCancel_pullbackComp` | 1578 | `_legs` step (iii) cancellation 3 |
| `base_change_mate_inner_value_eq` | 1635 | cascade via `_fstar_reindex` |

All three eCancel atoms are **out of scope** at the `_legs` sorry (line 1472). They cannot be referenced inside `_legs`'s proof block as the file currently stands. Similarly the missing link sub-lemmas L3–L5 (`link_cancelEUnit`, `link_cancelPullbackComp`, `link_survivor`) also cannot be placed between `_legs` and the eCancel atoms because the eCancel atoms would still be out of scope.

**Required prover action**: move `base_change_mate_inner_eCancel_eUnit`, `_pushforwardComp`, `_pullbackComp` to **before** `base_change_mate_fstar_reindex_legs` in the Lean file, then write the link sub-lemmas L3–L5 in between, and use them to close the `_legs` sorry. The blueprint's chapter ordering reflects this (link lemmas appear before `_legs`; the eCancel atoms appear in a later narrative section that is consistent with either ordering because the blueprint has no forward-reference constraint).

### Dangling `\lean{...}` Pins — L2–L4 Link Sub-Lemmas

The following three blueprint blocks carry `\lean{...}` pins naming declarations that **do not exist** in the Lean file:

| Blueprint block | `\lean{}` pin | In Lean? | `\leanok`? |
|---|---|---|---|
| `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit` | `…link_cancelEUnit` | **NO** | No |
| `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp` | `…link_cancelPullbackComp` | **NO** | No |
| `lem:base_change_mate_fstar_reindex_legs_link_survivor` | `…link_survivor` | **NO** | No |

These are unformalized intermediate steps — the blueprint correctly has no `\leanok` markers for them, but the `\lean{...}` pins reference non-existent targets. This will cause blueprint-doctor / leandag errors if these pins are checked. The iter-030 review flagged L1–L5; only L1 (fused as `link_distributeCollapse`) is resolved. L2–L4 remain dangling.

Note: L1 (`link_distributeCollapse`) is confirmed resolved — `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}` exists and has `\leanok`. ✓

### Excuse-comments — ACCEPTABLE (not red flags)

`base_change_mate_section_identity` (line 1873) and `pushforward_base_change_mate_cancelBaseChange` (line 1943) both state explicitly in their docstrings: "body has no inline `sorry`" and "transitively `sorry`-backed through `base_change_mate_gstar_transpose`." This is transparent and correct; it is not an excuse-comment trying to hide wrong code. **Not a red flag.**

The in-proof comment at `_legs` lines 1455–1471 (describing the residual telescoping) is documentation of known open work, not an excuse-comment. **Not a red flag.**

### Axioms / Classical.choice
None observed. No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

All substantive declarations in the Lean file are referenced by `\lean{...}` blocks in the blueprint. No unreferenced substantive declarations found.

Helper instances:
- `pullback_isEquivalence_of_iso` (line 762) is `\lean`-pinned (`lem:pullback_isEquivalence_of_iso`) and marked `\leanok`. ✓

---

## Blueprint adequacy for this file

### Coverage
All 40+ Lean declarations have a corresponding `\lean{...}` block in the chapter. The three missing link sub-lemma declarations (L3–L5) have `\lean{...}` pins reserved — the blueprint anticipates them correctly.

- **Coverage**: effectively 100% — every substantive Lean declaration maps to a blueprint block.

### Proof-sketch depth
**Adequate** for all proved lemmas. For the two live sorries:

- **`lem:base_change_mate_fstar_reindex_legs`**: proof sketch is detailed at four levels — step (i) `subst`, step (ii) `simp only` Γ-collapse, step (iii) four clean-term links with named sub-lemmas. The congruence-lifting technique (term-mode `congrArg`/`.trans`/`exact` for the nested-image vs composed-functor object diamond) is explicitly documented in `lem:base_change_mate_inner_eCancel_assemble` (lines 2319–2337 of the blueprint). The `eCancel` ordering constraint (atoms must come first in the Lean file) is implied by the blueprint's chapter ordering (link sub-lemmas appear before `_legs` in the chapter) but not made explicit. **Recommendation**: add a `% NOTE:` to `lem:base_change_mate_fstar_reindex_legs` stating that the eCancel atoms must be placed before `_legs` in the Lean file.

- **`lem:base_change_mate_gstar_transpose`**: four-move recipe (counit factorization → counit transport Seam C → inner value Seam A → generator close Seam B) is adequate. The note about term-mode surgery for the nested-image vs composed-functor diamond is in `lem:base_change_mate_inner_eCancel_assemble`.

### Hint precision
**Precise** on all existing declarations. The three dangling pins (L3–L5) are precisely named; they only need the corresponding Lean declarations to be created.

### Generality
Matches need throughout.

### Recommended chapter-side actions

1. **Add ordering note** to `lem:base_change_mate_fstar_reindex_legs`: `% NOTE: In the Lean file the eCancel atoms (base_change_mate_inner_eCancel_eUnit/_pushforwardComp/_pullbackComp) must appear BEFORE this lemma (since Lean enforces linear ordering). Move them up; then add the three link sub-lemmas L3–L5 after the atoms and before this lemma.`
2. **Retain L3–L5 `\lean{}` pins** pending formalization (they are correctly without `\leanok`).
3. No other blueprint-side actions needed; the chapter is well-specified for the remaining work.

---

## Severity summary

| Finding | Severity |
|---|---|
| Declaration-ordering: eCancel atoms out of scope at `_legs` sorry — blocks closing the sorry | **major** |
| Dangling `\lean{}` pins: `link_cancelEUnit`, `link_cancelPullbackComp`, `link_survivor` not in Lean | **major** |
| Iter-031 advance (`simp only [base_change_mate_codomain_read_legs, …]`) confirmed genuine | informational |
| 4 sorries all known and gated (`_legs`, `gstar_transpose`, affine, FBC-B) | informational |
| No misleading "sorry-free" docstrings (disclosure is transparent) | informational |
| No dead `set`/`have`, no axioms | informational |

**Overall verdict**: The Lean file faithfully follows the blueprint for all proved declarations; the two live sorries (`_legs` and `gstar_transpose`) match the blueprint's expected cruxes precisely. The primary actionable issue is the declaration-ordering constraint — the eCancel atoms (`_eUnit`, `_pushforwardComp`, `_pullbackComp`) and the three missing link sub-lemmas (`link_cancelEUnit`, `link_cancelPullbackComp`, `link_survivor`) must appear **before** `base_change_mate_fstar_reindex_legs` in the Lean file for the `_legs` sorry to be closeable. The blueprint chapter ordering already reflects this (link lemmas precede `_legs` in the chapter), but the constraint should be made explicit in a `% NOTE:` comment.
