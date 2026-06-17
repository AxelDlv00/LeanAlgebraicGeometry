# blueprint-writer bw257-eng — report

Edited ONLY `blueprint/src/chapters/Picard_LineBundleCoherence.tex`. All three directed corrections applied.

## Correction 1 (MUST-FIX) — finiteness bridge named in both proof sketches — DONE

- **`lem:lbc_chart_presentation` proof block** (now L185–213): added the concrete recipe. The chart
  presentation is built by transporting the canonical finite free presentation `σ` of
  `SheafOfModules.unit (U_i).ringCatSheaf` along the trivialisation iso, via
  `SheafOfModules.Presentation.ofIsIso e_i.hom`. Stated explicitly that the Mathlib instance making
  `(ofIsIso f σ).IsFinite` hold when `σ.IsFinite` holds means the result's `IsFinite` is inferred by
  typeclass resolution — so NO separate 6th declaration `chartPresentation_isFinite` is required; the
  `IsFinite` datum rides along as an instance on the `ofIsIso`/`chartPresentation` construction.
  Confirmed in prose that the canonical `SheafOfModules.unit` presentation is the rank-one free
  presentation and is finite (citing the unit finite-presentation instance).
- **`thm:lbc_isFinitePresentation` proof block** (now ~L235–244): noted each chart's `IsFinite` is the
  automatic `ofIsIso` instance from `chartPresentation` (not supplied by hand), so the
  `QuasicoherentData.IsFinitePresentation` finiteness obligation is discharged by inference; then invoke
  `SheafOfModules.IsFinitePresentation.mk` (equivalently the anonymous `⟨⟨…⟩⟩` constructor). The point the
  prover needs — `IsFinite` discharged by inference, not a separate lemma — is now explicit in both places.

## Correction 2 (MUST-FIX) — false proof-block `\leanok` removed — DONE

Removed the single erroneous `\leanok` from the `lem:lbc_chart_presentation` proof block (was on the old
line 187). `chartPresentation` is an iter-256 `sorry` stub, so the marker was a purity violation. No new
markers added anywhere. The `\leanok` on the lemma *statement* line (L148) was left untouched (statement
markers are sync-managed and out of scope of the reviewer's one-off request).

## Correction 3 (minor) — two overclaims softened — DONE

- **`cor:lbc_isFiniteType`**: retitled to "Locally trivial ⟹ finite type"; prose now states `IsFiniteType`
  is the named result and that `IsQuasicoherent` follows automatically via the Mathlib instance
  `SheafOfModules.instIsQuasicoherentOfIsFinitePresentation` (no separate named theorem). Proof block
  updated to match: quasi-coherence is "not separately stated in the Lean type" but available as the
  instance.
- **`lem:lbc_rank_flat`** (`chart_free_rank_one`): statement kept; prose made honest — the Lean type records
  only the chart-local iso `M|_U ≅ 𝒪_U` (to `unit`), which is the rank-one free *model*; rank-one freeness
  and flatness are *consequences* of that iso, not separately stated in the type (Mathlib has no
  SheafOfModules-level rank/flat predicate). No longer reads as a stronger claim than the type supports.

## Out of scope — respected

- No other chapter edited.
- Verbatim Stacks `% SOURCE QUOTE` citation blocks left intact.
- No new `\leanok`/`\mathlibok` added (Correction 2 only removed one).

## Verification notes

- Bridge names (`SheafOfModules.Presentation.ofIsIso`, `SheafOfModules.unit`, `IsFinitePresentation.mk`,
  `instIsFiniteTypeOfIsFinitePresentation`, `instIsQuasicoherentOfIsFinitePresentation`) match the names
  already used by the Lean skeleton `AlgebraicJacobian/Picard/LineBundleCoherence.lean` docstrings and the
  directive. `M.over U` / `M.restrict U.ι` carrier distinction in the chart presentation prose matches the
  Lean `chartPresentation` signature (`e : M.restrict U.ι ≅ unit …` → `(M.over U).Presentation`).
- LaTeX: anonymous-constructor glyphs written as `\langle\langle\dots\rangle\rangle`; underscore in
  `chartPresentation\_isFinite` escaped.
