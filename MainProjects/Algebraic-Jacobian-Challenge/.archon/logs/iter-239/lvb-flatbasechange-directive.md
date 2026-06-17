# lean-vs-blueprint-checker directive — iter-239 — FlatBaseChange

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

This iter added two project-local declarations realizing blueprint content:
- `gammaPushforwardIsoAt` — the open-indexed generalization of `gammaPushforwardIso` (blueprint movement (1),
  `e_{D(a)}`). It is NOT currently `\lean{}`-pinned in the chapter. Report whether the chapter should pin it
  (and to which label) or whether it is adequately covered by `lem:gammaPushforwardIso`.
- `tildeRestriction_isLocalizedModule` — the `R'`-side localization input used inside the `hloc` discharge.
  Also not `\lean{}`-pinned. Report whether a block should pin it.
- `pushforward_spec_tilde_iso` (`\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}`, `lem:pushforward_spec_tilde_iso`)
  now resolves to a real but `sorry`-bearing decl (the `hloc` obligation is open). Check the proof sketch in the
  chapter still faithfully describes the Lean route (the `of_linearEquiv` finish via `gammaPushforwardIsoAt` at
  `⊤` and `D(a)`), and flag any place the chapter over-claims completion.

Report bidirectionally: (a) Lean → blueprint (fake/placeholder statements, signature mismatches, unpinned new
decls); (b) blueprint → Lean (is the chapter detailed enough to guide the `hloc` close, or too thin?). Mark any
must-fix-this-iter finding explicitly. Write to `task_results/lean-vs-blueprint-checker-flatbasechange.md`.
