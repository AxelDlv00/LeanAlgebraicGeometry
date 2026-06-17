# Blueprint Writer Report

## Slug
quot-iter020

## Status
COMPLETE — both jobs delivered; leandag clean (no unknown_uses, no conflicts, no new isolated nodes).

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Job A — base-case argument for the keystone induction (route b)

- **Added lemma** `\lemma`/`\label{lem:graded_subquotient_base_eventuallyZero}`/
  `\lean{AlgebraicGeometry.GradedModule.subquotient_base_eventuallyZero}` — its own block
  in the "The base case ($r = 0$)" subsubsection, between
  `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite` and the induction.
  - Statement: a length-0 subquotient datum has an eventually-zero ambient Hilbert function,
    hence `IsRatHilb(hilb, 0)`.
  - Proof sketch carries the three required steps rigorously:
    1. **Independence (the residual leaf):** `(range ψ_n)_n` is `iSupIndep` in the
       finite-dimensional `Q₀ = N/N'`, via the ambient direct-sum grading of `M` and
       homogeneity of `N'` (degree-`n` component comparison).
    2. **Finiteness of support:** `Submodule.finite_ne_bot_of_iSupIndep` ⇒ only finitely many
       ranges nonzero ⇒ bounded above.
    3. **Eventual vanishing → rationality:** beyond the threshold `N ∩ ℳ_n ≤ N'`, so
       `hilb(n)=0`; `lem:ratHilb_ofEventuallyZero` finishes.
  - **Route discipline recorded in `% NOTE:` blocks inside the proof:**
    - ROUTE (b) — USE THIS: dfinsupp destructuring (`Submodule.mem_iSup_iff_exists_dfinsupp`)
      + degree-`n` component read off directly inside `Q₀`'s κ-structure, no outgoing map.
    - ROUTE (a) — DEAD END: the `Submodule.liftQ` κ-linear detector `Φ` clashes on the
      scalar ring (`MvPolynomial(∅,κ)`-semilinear vs κ-target).
  - `\uses{}`: `def:graded_subquotientHilb`,
    `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite`,
    `lem:graded_homogeneousSubmodule_iSupIndep`,
    `lem:finite_ne_bot_of_iSupIndep_mathlib`, `lem:ratHilb_ofEventuallyZero`.
  - Citation: `% SOURCE`/`% SOURCE QUOTE` on the Tag-00K1 base-case sentence
    ("If this number is 0, then $M_n = 0$ for all $n \gg 0$…", verbatim from
    `references/hilbert-serre-algebra.tex` L13908–L13910) + visible `\textit{Source: …}`.
- **Revised** `lem:graded_subquotient_isRatHilb` — base case in the proof now cites
  `\cref{lem:graded_subquotient_base_eventuallyZero}` (replacing the old hand-wave "M is
  finite-dimensional, hence N∩ℳ_n=0"), and the lemma's statement-level and proof-level
  `\uses{}` gained `lem:graded_subquotient_base_eventuallyZero` (plus
  `def:graded_subquotientDatum_ker`/`_coker` for the step's actual constructors).

## Job B — coverage-debt helper nodes (16 blocks, all matched)

New subsubsection **"Finiteness-transfer infrastructure"** (before "Ambient finiteness transfer"):
- **Added definition** `def`/`\label{lem:graded_lastVarAlgHom}` — ONE block with seven
  `\lean{}` pins covering `lastVarAlgHom`, `lastVarAlgHom_X_castSucc`, `_X_last`, `_C`,
  `_rename_castSucc`, `_surjective`, instance `lastVarAlgHom_ringHomSurjective`. Uses:
  `lem:fg_restrictScalars_of_surjective_mathlib`.
- **Added lemma** `lem:graded_polyEndHom_mem_of_stable` — `t`-stable submodule closed under
  `polyEndHom`. Uses `def:graded_polyEndHom`, `lem:graded_polyEndHom_X`/`_C`.
- **Added lemma** `lem:graded_polyEndHom_lastVar_sub_mem` — mod-`P'` semilinearity heart.
  Uses the polyEndHom blocks + `lem:graded_lastVarAlgHom`.
- **Added lemma** `lem:graded_polyQuot_finite_of_le_numerator` — shrink-numerator finiteness.
  Uses `lem:module_finite_of_injective_mathlib`,
  `lem:mvPolynomial_isNoetherianRing_fin_mathlib`,
  `lem:isNoetherian_of_isNoetherianRing_of_finite_mathlib`.
- **Added lemma** `lem:graded_polyQuot_finite_of_le_denominator` — enlarge-denominator
  finiteness. Uses `lem:module_finite_of_surjective_mathlib`, `lem:submodule_liftQ_mathlib`.

New subsubsection **"Subquotient constructors"** (after "Ambient finiteness transfer"):
- **Added lemma** `lem:graded_ker_stable_full` / **lemma** `lem:graded_coker_stable_full` —
  full-family stability of the kernel/cokernel pairs. Use
  `lem:graded_comap_map_le_of_commute` / `lem:graded_map_map_le_of_commute`.
- **Added definition** `def:graded_subquotientDatum_ker` (`SubquotientDatum.ker`) and
  **definition** `def:graded_subquotientDatum_coker` (`SubquotientDatum.coker`) — the two
  length-`(r+1)→r` constructors, with `\uses{}` wiring the homogeneity/nesting/annihilation
  calculus, the stable-full lemmas, `lem:graded_subquotient_finite_transfer`, and the
  matching `polyQuot_finite_of_le_*` block for the `hfin` field.

**Revised** `lem:graded_subquotient_finite_transfer` — re-stated as the **abstract single-pair
σ-transfer along `lastVarAlgHom`** (the landed Lean form), not the K,C-specific phrasing.
Statement now: single pair `P' ≤ P` stable under `t_0…t_r` with `x=t_r` annihilating `P/P'`
and `P/P'` finite over `κ[t_0…t_r]` ⇒ finite over `κ[t_0…t_{r-1}]`. Proof rewritten around the
σ-semilinear quotient map + `Submodule.liftQ` + `Module.Finite.of_surjective`. `\uses{}` now
includes `lem:graded_lastVarAlgHom`, `lem:graded_polyEndHom_lastVar_sub_mem`,
`lem:module_finite_of_surjective_mathlib`, `lem:submodule_liftQ_mathlib` (kept
`lem:fg_restrictScalars_of_surjective_mathlib` for the ring-surjection rationale); dropped the
stale K,C `\uses` edges, which now live on the constructors.

**`finrank_comap_subtype`** — recorded as an intentionally-`private` implementation detail of
the D₆ identity via a prose-only `% NOTE:` in the `lem:graded_subquotient_degreewise_diff`
block. No public `\lean{}` pin (it would not resolve); remains the expected 18th unmatched node.

## Mathlib dependency anchors added (`\mathlibok`)
All in the existing "Mathlib dependency anchors" subsubsection; each `\lean{}` target is used
verbatim in the QuotScheme Lean source (and was [verified] in the prover's plan-pin list):
- `lem:module_finite_of_surjective_mathlib` → `Module.Finite.of_surjective`
- `lem:module_finite_of_injective_mathlib` → `Module.Finite.of_injective`
- `lem:submodule_liftQ_mathlib` → `Submodule.liftQ`
- `lem:finite_ne_bot_of_iSupIndep_mathlib` → `Submodule.finite_ne_bot_of_iSupIndep`
- `lem:mvPolynomial_isNoetherianRing_fin_mathlib` → `MvPolynomial.isNoetherianRing_fin`
- `lem:isNoetherian_of_isNoetherianRing_of_finite_mathlib` → `isNoetherian_of_isNoetherianRing_of_finite`

## Cross-references introduced
All resolve (leandag `unknown_uses: []`). New ↔ existing edges verified via
`leandag build --json` + `.leandag/dag.json` node inspection: every new `\lean{}` pin matched
its exact Lean declaration (16/16 helper blocks, 6/6 anchors). No `\leanok` added (markers left
to `sync_leanok`); pre-existing `\leanok` on the revised `finite_transfer` block preserved.

## References consulted
- `references/hilbert-serre-algebra.tex` (L13905–13950) — verbatim Tag-00K1 base-case sentence
  for `lem:graded_subquotient_base_eventuallyZero`'s `% SOURCE QUOTE`; confirmed the Stacks
  proof asserts "$M_n = 0$ for $n \gg 0$" without the κ-vector-space independence detail (so
  the independence argument is correctly written as project-bespoke, no new retrieval).

## Macros needed
- None. All commands used already exist in `macros/common.tex` / are standard.

## Reference-retriever dispatches
- None (no new source needed; the base-case independence argument is project-bespoke as the
  directive anticipated).

## Notes for Plan Agent
- Pre-existing out-of-scope unmatched Lean decls remain (not touched per directive):
  `AlgebraicGeometry.sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`,
  `Scheme.hilbertPolynomialOfSectionModule`, and the `Grassmannian.scheme/isSeparated/isProper`
  skeleton — these are the blocked-on-Mathlib / Grassmannian hygiene items flagged as separate.
- The Mathlib-anchor `\texttt{module path}` parentheticals (e.g. `Mathlib.RingTheory.Noetherian.Defs`)
  are cosmetic prose; the binding `\lean{}` targets are what leandag matches and all resolve.
  Reviewer may wish to confirm exact module paths at typeset time if desired.

## Strategy-modifying findings
None. The base case is provable exactly as the strategy assumes (ambient subquotient route,
route b); no strategy-level issue surfaced.
