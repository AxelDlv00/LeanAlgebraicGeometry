# Blueprint Writer Report

## Slug

rigiditykbar-d-app-d-map-iter141

## Status

COMPLETE

All four directive updates landed inside the `\begin{proof}` block of
`\cref{lem:GrpObj_omega_basechange_proj}` in
`blueprint/src/chapters/RigidityKbar.tex`. All edits are confined to
LaTeX comment lines (`%`-prefixed prose + commented `\begin{verbatim}`
demonstration block), matching the existing iter-138/139/140 NOTE-block
style. File grows from 1242 lines to 1349 lines (+107). LaTeX block
counts balanced (`begin{enumerate}` = `end{enumerate}` = 4;
`begin{proof}` = `end{proof}` = 12; `begin{verbatim}` =
`end{verbatim}` = 2, both inside `%`-comment lines so never entered).

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex`

## Changes Made

- **Update 1 (d_app Implementation note)** — Inserted a ~32-line
  "Implementation note (iter-141)" after the 3-step categorical-chase
  recipe (immediately before the `NOTE iter-138 (d_map closure recipe)`
  header, at the previous L660). The note:
  - Names `ModuleCat.Derivation.d_map`
    (`Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:80`)
    as the algebra-side closing lemma; explicitly states "NOT
    `Derivation.map_algebraMap`" with the rationale that
    `ModuleCat.Derivation.d_map` packages the
    `Algebra`/`Module`/`IsScalarTower` instance discharge + the
    `map_algebraMap` call into a single `@[simp]` lemma.
  - Embeds the standalone-validated `lean_run_code` streamlined
    pattern (per `analogies/d-app-d-map-recipe-shape.md` Decision 1)
    inside a commented `\begin{verbatim}` ... `\end{verbatim}` block.
  - Notes the ~4-LOC-per-call-site saving over the iter-140
    `letI + map_algebraMap` chain.
  - Gives the combined d_app closure LOC estimate (~50–90 LOC =
    ~40–80 LOC for the categorical witness `h` + ~5–10 LOC for the
    algebra-side discharge via `d_map`).

- **Update 2 (d_map named-lemma + `whnf`-disabled advisory)** —
  Replaced the previous L702–708 "definitional/transparent +
  `pushforward = pushforward₀ ∘ restrictScalars`, leaving no opacity to
  chase" claim with a ~55-line revised closure recipe:
  - **Named-lemma advisory**: `PresheafOfModules.pushforward_obj_map_apply'`
    at `Pushforward.lean:99–106` is the explicit `@[simp]`-tagged
    unfolding lemma; use `simp only [pushforward_obj_map_apply']`,
    NOT `change` or other `whnf`-based tactics.
  - **`whnf`-disabled advisory**: cites the `set_option
    backward.isDefEq.respectTransparency false in` annotation on
    `pushforward₀_obj` and `pushforward₀` at `Pushforward.lean:37, 55`;
    cites the iter-140 empirical validation of the deterministic
    heartbeat timeout at `maxHeartbeats=200000` (cross-ref
    `task_results/Cotangent_GrpObj.lean.md` §"d_map: detailed gap"
    L111–L143).
  - **Three-step ALIGN_WITH_MATHLIB chase** (per the iter-141
    analogist's Decision 4):
    1. `simp only [PresheafOfModules.pushforward_obj_map_apply']`
       for the RHS unfolding.
    2. `NatTrans.naturality` for ψ
       (`(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`, which is
       `(snd G G).left.c` whiskered with `forget₂` per
       `Mathlib/AlgebraicGeometry/Modules/Presheaf.lean:42–45`).
    3. `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
       (`Presheaf.lean:201–207`) for the universal Kähler derivation
       commutation.
  - LOC estimate for d_map closure (~30–50 LOC).

- **Update 3a (Negative-lesson note in d_map block)** — Appended a
  6-line "Negative-lesson note (iter-141)" inside the d_map NOTE
  block, after the new three-step chase. The note explicitly
  distinguishes the d_add/d_mul-style `change`-first pattern (valid
  there because the RHS is a pure `KaehlerDifferential.D`-applied
  term) from the d_map case (RHS carries
  `((pushforward ψ).obj LHS).map f`, and `pushforward₀`'s
  transparency annotation blocks `whnf`). Advises future iters NOT
  to re-attempt the `change`-first approach on `pushforward`-
  transposed goals.

- **Update 3b (IsIso gap-items framing repair, originally L917–928,
  now L1014–1039)** — Updated the "Iter-140 prover gap items, in
  build order" enumerate at the bottom of the IsIso Route (b'2)
  recipe block. Added a 6-line "Iter-140 update" preamble that:
  - Records that item (1), the iso-reflection bridge
    `isIso_of_app_iso_module`, is closed at
    `Cotangent/GrpObj.lean:544–550`.
  - States that items (2)–(4) remain iter-141+ targets.
  - Pins the exact residual sorry type at
    `Cotangent/GrpObj.lean:689`: `∀ X, IsIso ((basechange_along_proj_two_inv G).app X)`
    (iter-140 narrowed from "whole iso" `letI := sorry` to the
    per-open variant inside
    `isIso_of_app_iso_module ... (fun _ => sorry)`).
  - Re-labelled each enumerate item with status tags
    `[iter-140 closed]` (item 1) or `[iter-141+ target]` (items 2–4),
    preserving the original LOC estimates verbatim.

- **Update 4 (iter-139 NOTE block staleness, L491–504, now L499–522)** —
  Inserted a 1-paragraph "Iter-141 update (pattern-citation only)"
  immediately before the `\leanok` marker on the proof block. The
  note:
  - Cites that iter-140 moved the `letI : IsIso ... := sorry`
    pattern to a `(fun _ => sorry)` argument inside the iter-140-
    landed `isIso_of_app_iso_module` helper (at
    `Cotangent/GrpObj.lean:689`).
  - Confirms the underlying `sync_leanok` mis-mark concern persists
    (sorry still present in the proof body → `\leanok` remains a
    mis-mark candidate until iter-142+ closes the per-open `IsIso`
    sub-sorry).

## Cross-references introduced

- No new `\uses{...}` introduced; no new `\label{...}` or `\lean{...}`
  introduced. All edits are inside existing NOTE blocks of an existing
  proof block, in `%`-comment form.

## Macros needed (if any)

- None. All edits use existing macros (`\texttt`, `\emph`, `\textbf`,
  `\sim`, `\cref`, `\circ`, `\app`, `\mathrm`).

## Reference-retriever dispatches (if any)

- None. The directive's sources
  (`task_results/mathlib-analogist-d-app-d-map-iter141.md`,
  `analogies/d-app-d-map-recipe-shape.md`,
  `task_results/Cotangent_GrpObj.lean.md`,
  `task_results/blueprint-reviewer-iter141.md`) supplied all required
  named lemmas, Mathlib file paths, line numbers, and recipe details.
  No new external reference summary needed.

## Notes for Plan Agent

- The directive's expected outcome ("the chapter is ready for the
  iter-142 prover lane on d_app + d_map sub-sorries (combined ~80–140
  LOC, well within the renormalised 1000 LOC arm)") is materially
  satisfied. The d_app Implementation note pinpoints
  `ModuleCat.Derivation.d_map` with the exact `lean_run_code`-validated
  example; the d_map advisory + three-step chase recipe pinpoint
  `pushforward_obj_map_apply'` and the order of `simp` /
  `NatTrans.naturality` / `relativeDifferentials'_map_d` calls; the
  IsIso gap-items list now reflects iter-140 actual progress; the
  iter-139 NOTE block pattern-citation is dated-but-the-concern-
  preserved.

- Out-of-scope per directive (and untouched):
  - IsIso Route (b'2) recipe text at L842–L958 (now shifted to ~L935–L1053).
  - d_app / d_map blueprint signature stubs at L456–L472 and the
    `\lean{...}` blocks.
  - `\notready` markers on statement blocks; `\leanok` markers on
    proof blocks (review-agent / `sync_leanok` territory).
  - Iter-138/139/140 NOTE blocks beyond Updates 3+4.
  - All chapters other than `RigidityKbar.tex`.

- The iter-141 blueprint-reviewer's "iter-140 NOTE for per-open IsIso
  sub-sorry pin" recommendation was folded into Update 3 (the IsIso
  gap-items list now states the exact residual sorry type) rather
  than added as a separate NOTE block; this avoids a fifth NOTE block
  in the same proof.

## Strategy-modifying findings

None. The four updates land facts already established by the iter-141
mathlib-analogist (`d-app-d-map-iter141`) and blueprint-reviewer
(`iter141`); no strategy-level surprise surfaced during writing. The
active critical path (genus-0 Albanese witness via shared cotangent-
vanishing pile, piece (i.b) Step 2 the current blocker) is unchanged.
