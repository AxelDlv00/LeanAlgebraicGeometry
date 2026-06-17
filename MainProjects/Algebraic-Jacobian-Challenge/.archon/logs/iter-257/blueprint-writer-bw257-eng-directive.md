# blueprint-writer bw257-eng — fix `Picard_LineBundleCoherence.tex` (finiteness bridge + false marker)

Edit ONLY `blueprint/src/chapters/Picard_LineBundleCoherence.tex`. Three corrections.

## Correction 1 (MUST-FIX) — add the finiteness bridge to the `chartPresentation` / `isFinitePresentation` proof sketches

The Lean main theorem `isFinitePresentation` needs `(chartPresentation M U e).IsFinite` to build a
`SheafOfModules.QuasicoherentData.IsFinitePresentation`. The current chapter says "transport the
presentation along the trivialisation" / "feed to `SheafOfModules.IsFinitePresentation.mk`" but does NOT
name the bridge. Add the concrete recipe (verified against Mathlib `…/SheafOfModules/Quasicoherent.lean`):

- In the proof sketch of `lem:lbc_chart_presentation`: build `chartPresentation M U e` by transporting the
  canonical finite free presentation of `SheafOfModules.unit (U : Scheme).ringCatSheaf` along the
  trivialisation iso, via `SheafOfModules.Presentation.ofIsIso e.hom` (Mathlib). State that the Mathlib
  instance making `(ofIsIso f σ).IsFinite` hold when the source presentation `σ.IsFinite` holds means the
  result's `IsFinite` is inferred automatically by typeclass resolution — so NO separate 6th declaration
  `chartPresentation_isFinite` is required; the finiteness rides along as an instance on the `ofIsIso`
  construction. (Confirm/State that the canonical presentation of `SheafOfModules.unit R` is finite — it
  is the rank-one free presentation — citing the Mathlib unit-presentation instance.)
- In the proof sketch of `thm:lbc_isFinitePresentation`: assemble the `QuasicoherentData` from the
  trivialising cover (`exists_trivializing_cover`) with `chartPresentation` at each chart, note that each
  chart's `IsFinite` is the automatic instance from `ofIsIso`, and invoke
  `SheafOfModules.IsFinitePresentation.mk` (or the anonymous `⟨⟨…⟩⟩` constructor) on that data. The point
  the prover needs: the `IsFinite` obligation is discharged by inference, not a separate lemma.

## Correction 2 (MUST-FIX) — remove the false proof-block `\leanok`

The proof block of `lem:lbc_chart_presentation` currently carries a `\leanok` (manually inserted in error
when the chapter was written), but `chartPresentation` is an iter-256 `sorry` stub. Per the
blueprint-reviewer (br257) this is a purity violation: a proof-block `\leanok` asserts the proof is closed,
which is false. REMOVE that single erroneous `\leanok` from the `chartPresentation` proof block so the
chapter reflects the true (unproved) state. (`\leanok` is otherwise sync-managed; this is a one-off removal
of a demonstrably-false manual marker, explicitly requested by the reviewer — do NOT add any new markers.)

## Correction 3 (minor) — soften two overclaims

- `cor:lbc_isFiniteType`: the prose claims both `IsFiniteType` AND `IsQuasicoherent`; the Lean states only
  `IsFiniteType`. Soften to: `IsFiniteType` is the named result; `IsQuasicoherent` follows automatically
  from `isFinitePresentation` via a Mathlib instance (no separate named theorem needed).
- `lem:lbc_rank_flat` (`chart_free_rank_one`): the prose claims "free of rank one, in particular flat", but
  the Lean type only records the chart-local iso `M|_U ≅ 𝒪_U` (Mathlib has no SheafOfModules-level
  rank/flat predicate). Keep the statement, but make the prose honest: this records the rank-one free
  MODEL via the iso to `unit`; rank-one freeness and flatness are consequences of that iso, not separately
  stated in the type. (This keeps it from reading as a stronger claim than the type supports.)

## Out of scope
Do NOT edit any other chapter. Keep the verbatim Stacks `% SOURCE QUOTE` citation blocks intact. Do NOT
add any `\leanok`/`\mathlibok`.
