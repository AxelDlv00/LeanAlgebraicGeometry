# Lean ↔ Blueprint Check Report

## Slug
quot-iter043

## Iteration
043

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (2550 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (5328 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_hP1}` — NO blueprint block (iter-043 new decl)
- **Lean target exists**: yes (line 2457, axiom-clean per iter-043 prover result)
- **Signature matches**: N/A — no blueprint block exists to compare against
- **Proof follows sketch**: N/A
- **Notes**: This declaration (gap2 Piece B) has NO `\lean{...}` pin in the blueprint. It is the "eqToHom bridge" step that factors the gap-2 transport given the P1 datum as an explicit hypothesis `hP1 : IsIso (...)`. Without a pin, `sync_leanok` cannot track its axiom-clean status. See "Unreferenced declarations" and "Blueprint adequacy" sections for the fix recommendation.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (`lem:qcoh_section_localization_basicOpen`)
- **Lean target exists**: no — correctly absent; gap2 target is still open (Piece A missing)
- **Signature matches**: N/A (no declaration to check)
- **Proof follows sketch**: N/A
- **Notes**: Blueprint block has no `\leanok`. The `\uses` cone is adequate: `lem:qcoh_pullback_fromSpec` (Piece A), `lem:section_localization_hfr_aux_general` (core), `lem:fromSpec_image_top_section_coherence` (crux), `lem:isLocalizedModule_ringEquiv_semilinear` (bridge I). The proof sketch at lines 2513–2567 faithfully describes the three-step route (P1 datum → core → bridge). ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec}` (`lem:qcoh_pullback_fromSpec`)
- **Lean target exists**: no — correctly absent; Piece A is the iter-044 formalization target
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint block has no `\leanok`. The mathematical 5-step route (factorize `fromSpec = isoSpec⁻¹ ∘ U.ι` → QC-under-iso → reduce to `(pullback U.ι).obj M` → cover-refine `{U ⊓ V_i}` → `Presentation.map` per member) is clearly stated. The `\uses` cone correctly lists `def:over_restrict_presentation` and `def:presentation_pullback_iota_of_quasicoherentData`; `def:overRestrictUnitIso` is transitively covered through `def:over_restrict_presentation`, so the DAG is adequate. See "Blueprint adequacy" for the under-specified Lean friction point.

### `\lean{AlgebraicGeometry.Scheme.Modules.section_localization_hfr_aux_general}` (`lem:section_localization_hfr_aux_general`, leanok)
- **Lean target exists**: yes (line 2321)
- **Signature matches**: yes — takes `(M : X.Modules)`, `(j : Spec S ⟶ X)` open immersion, P1 hypothesis `IsIso M'.fromTildeΓ`, slice element `f' : S`, image section `f`, transport coherence `σ f' = f`; returns `IsLocalizedModule (powers f) (restrictₗ M ⟨j ''ᵁ D(f'), j ''ᵁ ⊤⟩)`. Matches blueprint statement at lines 2640–2650. ✓
- **Proof follows sketch**: yes — Lean proof chain (P1 → `isLocalizedModule_restrict_of_isIso_fromTildeΓ` → `gammaPullbackImageIso` isos `e₁,e₂` → semilinearity → bridge (I) → `Submonoid.map_powers` rewrite) mirrors the blueprint proof sketch at lines 2652–2673. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.fromSpec_image_top_section_coherence}` (`lem:fromSpec_image_top_section_coherence`, leanok)
- **Lean target exists**: yes (line 2288)
- **Signature matches**: yes — `ρ ∘ σ = id` for the top-level crux. ✓
- **Proof follows sketch**: yes ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent}` (`lem:qcoh_affine_section_localization`, leanok)
- **Lean target exists**: yes (line 2433)
- **Signature matches**: yes — `[M.IsQuasicoherent]` → `IsLocalizedModule (powers f) (restriction map)`. ✓
- **Notes**: Blueprint note at line 2891 accurately records that this is now a downstream corollary of gap1, not proved by a direct 3-field induction. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` (leanok)
- **Lean target exists**: yes (line 2417, within `Scheme.Modules` namespace at line 1159–2546)
- **Signature matches**: yes ✓

### Four top-level skeleton declarations (`:= sorry` bodies, `leanok` on statement block)
- `AlgebraicGeometry.Scheme.hilbertPolynomial` (line 123): `:= sorry`, blueprint `def:hilbert_polynomial` has `\leanok` on statement. Correct per AGENTS.md ("at least a sorry present"). ✓
- `AlgebraicGeometry.Scheme.QuotFunctor` (line 161): `:= sorry`, blueprint `def:quot_functor` has `\leanok` on statement. ✓
- `AlgebraicGeometry.Scheme.Grassmannian` (line 198): `:= sorry`, blueprint `def:grassmannian_scheme` has `\leanok` on statement. ✓
- `AlgebraicGeometry.Scheme.Grassmannian.representable` (line 225): `:= sorry`, blueprint `thm:grassmannian_representable` has `\leanok` on statement. ✓
- **Notes**: These four are gated stubs — not red flags. The skeleton bodies are documented as intentional ("file-skeleton body is a typed sorry") in the Lean module header (lines 122–228).

---

## Red flags

### Placeholder / suspect bodies
None on non-skeleton declarations. The four `:= sorry` bodies are all on explicitly-documented file-skeleton stubs for outer declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`), matching correctly un-`leanok`'d proof blocks in the blueprint. No covert placeholder.

### Excuse-comments
None found. No comments of the form "-- TODO replace with real def" or "-- wrong but works for now" on any substantive declaration.

### Axioms / Classical.choice on non-trivial claims
None. The iter-043 `isLocalizedModule_basicOpen_of_hP1` proof at lines 2457–2544 contains no `sorry`, no `axiom`, and no `Classical.choice` on a non-trivial claim.

---

## Unreferenced declarations (informational)

The following substantive non-private Lean declarations have no `\lean{...}` pin in the blueprint and should be assessed:

| Declaration | Line | Assessment |
|---|---|---|
| `isLocalizedModule_basicOpen_of_hP1` | 2457 | **Should have its own blueprint block** (see below) |
| `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` | 653 | Has pin at blueprint line 4885 (`AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict`) ✓ |
| `isLocalizedModule_basicOpen_of_presentation` | 686 | Has pin at blueprint line 2789 ✓ |
| `isIso_fromTildeΓ_restrict_basicOpen` | 1299 | Has pin at blueprint line 3698 ✓ |

**Key finding — `isLocalizedModule_basicOpen_of_hP1` has no blueprint pin.** This is the only substantive public theorem introduced this iteration that lacks coverage. It is classified as a `lean_aux` helper in the prover's terminology, but it is a full standalone theorem with a non-trivial statement and proof:
- It encapsulates steps 2+3 of the gap-2 transport (the "Applying the core" + "Bridging to the basic-open restriction" sub-route)
- Its explicit `hP1 : IsIso (...)` premise separates it cleanly from both the core (`section_localization_hfr_aux_general`, which needs no QC knowledge) and the full statement (`isLocalizedModule_basicOpen`, which needs Piece A to supply `hP1`)
- It will be directly cited in the eventual proof of `isLocalizedModule_basicOpen` once Piece A is complete
- Without a `\lean{...}` pin, `sync_leanok` cannot automatically verify its axiom-clean status

**Verdict on whether it maps to part (2) of `lem:qcoh_section_localization_basicOpen` or needs its own block:**
It should get **its own block**, NOT be absorbed into the proof sketch of `lem:qcoh_section_localization_basicOpen`. Reasons:
1. Its statement is strictly weaker than part (2) (it requires `hP1` as input, which the full lemma derives from Piece A + `lem:qcoh_affine_isIso_fromTildeΓ`).
2. The blueprint proof sketch of `lem:qcoh_section_localization_basicOpen` already describes the "Bridging" step in prose; a `\lean{}` pin makes the correspondence machine-checkable.
3. The declaration is axiom-clean and complete — `\leanok` is appropriate.

Suggested new block (to insert between `lem:section_localization_hfr_aux_general` and `lem:qcoh_pullback_fromSpec`):

```latex
\begin{lemma}\leanok
[Gap-2 eqToHom bridge from the P1 datum]
  \label{lem:qcoh_section_localization_basicOpen_of_hP1}
  \lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_hP1}
  \uses{lem:section_localization_hfr_aux_general, lem:fromSpec_image_top_section_coherence,
    lem:isLocalizedModule_ringEquiv_semilinear, lem:modules_restrict_basicOpen_linear,
    def:gamma_image_ring_equiv}
  Let $\mathcal{M}$ be a sheaf of modules on $X$, $U \subseteq X$ affine, and
  $\mathrm{hP1} : \mathrm{IsIso}(((\mathrm{pullback}\,\mathrm{fromSpec}).\mathrm{obj}\,
  \mathcal{M}).\mathrm{fromTildeΓ})$ the P1 datum. For $f \in \Gamma(X, U)$, the
  basic-open restriction $\mathrm{restrictBasicOpenₗ}\,\mathcal{M}\,f$ is
  $\mathrm{IsLocalizedModule}(\mathrm{powers}\,f)$ over $\Gamma(X, U)$.
  This is the ``Applying the core + Bridging'' sub-route of
  \cref{lem:qcoh_section_localization_basicOpen} part (2), factored with P1 explicit.
\end{lemma}
```

---

## Private declarations with `\lean{}` pins (informational)

The following are `private lemma`s in the Lean file but have public-looking `\lean{AlgebraicGeometry.Scheme.Modules.*}` pins in the blueprint, with `\leanok` markers:
- `iSup_basicOpen_subtype_eq_top` (line 1330) — blueprint line 3875
- `descent_surj` (line 1461) — blueprint line 3913
- `descent_smul_eq_zero` (line 1356) — blueprint line 3936
- `descent_overlap_agree` (line 1418) — referenced indirectly

The blueprint carries a note at line 500 about private declarations in the `IsRatHilb` subsection; no analogous note exists in the descent subsection. If `sync_leanok` uses LSP name resolution, private declarations will be unreachable under their qualified name, and `\leanok` may be spuriously removed. This is a pre-existing project issue, not introduced by iter-043.

---

## Blueprint adequacy for this file

### Coverage
The blueprint covers all substantive non-private public declarations in `QuotScheme.lean` except `isLocalizedModule_basicOpen_of_hP1` (gap from this iteration). All other public declarations have `\lean{...}` pins. Unreferenced private helpers are helpers — acceptable. The one missing pin is `isLocalizedModule_basicOpen_of_hP1`.

**Coverage: 38/39 substantive public declarations have `\lean{...}` pins. Missing: 1 (flagged above).**

### Proof-sketch depth

**For Piece B (`isLocalizedModule_basicOpen_of_hP1`) — already proved:** The proof sketch of `lem:qcoh_section_localization_basicOpen` part (2) (lines 2540–2566) and the proof sketch of `lem:section_localization_hfr_aux_general` (lines 2652–2674) together give a faithful and detailed roadmap for the Lean proof. The Lean proof follows the blueprint route step-for-step. **Adequate.**

**For Piece A (`lem:qcoh_pullback_fromSpec`) — iter-044 target:**
- The 5-step mathematical route is clearly stated (lines 2686–2715).
- The `\uses` cone covers the essential pieces: `def:over_restrict_presentation`, `def:presentation_pullback_iota_of_quasicoherentData`, `lem:presentation_map_mathlib`, `lem:modules_pullback_mathlib`.
- **Gap:** The blueprint does NOT mention the known Lean friction point: the `overRestrictUnitIso` coercion `↥V` vs `↥↑V` and the `IsContinuous` instance non-synthesis that the prover identified as the blocker in the slice-to-geometric transport step. The iter-043 memory records this as the "gateway friction" for Piece A. The blueprint proof sketch is **mathematically adequate** but **Lean-technically under-specified** at the coercion bridge. A `% NOTE:` comment would help iter-044 avoid the same dead end.

### Hint precision
All `\lean{...}` hints for proved declarations use fully-qualified names that match the actual Lean namespace. **Precise.**

Exceptions (correctly absent, no `\leanok`):
- `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen` — gap2 target, gated ✓
- `AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec` — Piece A, gated ✓

### Generality
Matches need — no over-narrowing or over-broadening observed. The blueprint's statement of `lem:qcoh_pullback_fromSpec` is at the right level (arbitrary quasi-coherent `M` on arbitrary scheme `X`, not specialized to affine X).

### Recommended chapter-side actions

1. **(major)** Add a `\begin{lemma}\leanok ... \lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_hP1} ...` block between `lem:section_localization_hfr_aux_general` and `lem:qcoh_pullback_fromSpec`. Use the suggested text above. This enables `sync_leanok` to track Piece B axiom-clean status.

2. **(major)** Add to `lem:qcoh_pullback_fromSpec`'s proof a `% NOTE:` about the coercion friction: "The `overRestrictUnitIso.symm` step encounters `↥V`/`↥↑V` coercion and `IsContinuous` non-synthesis in Lean 4; the prover should use `dsimp only` followed by explicit `IsIso` instance annotation, or work around the coercion via `eqToHom` transport." Without this guidance, the iter-044 prover is likely to hit the same blocker that stalled Piece A in iter-043.

3. **(minor)** Add a `% NOTE: The following declarations are \texttt{private} in the Lean source ...` comment in the descent lemma subsection (around `lem:iSup_basicOpen_subtype_eq_top`) parallel to the note at line 500 for the `IsRatHilb` subsection. This documents why `sync_leanok` may not automatically update their `\leanok` status.

---

## Severity summary

| Finding | Severity | Blocking? |
|---|---|---|
| `isLocalizedModule_basicOpen_of_hP1` has no `\lean{}` pin → `sync_leanok` blind to axiom-clean status | **major** | No — declaration is proved, issue is tracking only |
| `lem:qcoh_pullback_fromSpec` proof sketch lacks Lean-specific `% NOTE:` about `overRestrictUnitIso` coercion friction, risking repeated iter-044 blocker | **major** | No — mathematical route is correct, but omission may cost an iter |
| Private `descent_*` declarations `\leanok`'d but qualified names may not resolve in `sync_leanok` | minor | No |

**Overall verdict:** The chapter is broadly well-aligned with the Lean file — all proved declarations match their blueprint statements and proof sketches, and the two absent gap-2 declarations are correctly un-leanok'd. The two major findings are a missing `\lean{}` pin for the new iter-043 Piece B result, and a Lean-friction gap in the iter-044 Piece A proof sketch; neither blocks current progress but both should be addressed before iter-044 starts the Piece A proof.
