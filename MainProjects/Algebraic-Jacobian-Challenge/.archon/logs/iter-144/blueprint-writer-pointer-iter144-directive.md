# Blueprint Writer Directive

## Slug
pointer-iter144

## Target chapter
blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

## Strategy context

This is the pointer chapter for the Lean file
`AlgebraicJacobian/Cotangent/GrpObj.lean`. Its job is to enumerate the
in-file Lean declarations with one-line status, and to redirect the
reader to `RigidityKbar.tex` (specifically § "Piece (i)") for the
mathematical content.

The pointer chapter has drifted iter-by-iter behind the Lean file: it
last refreshed iter-138; iter-142 closed d_map substantively, iter-143
left d_app PARTIAL + extracted IsIso into a NEW named theorem.

The iter-144 user-hint chart-algebra pivot DESCOPES piece (i.b) Step 2
and piece (i.c) from critical-path iter-145+, but the named
declarations stay in-tree as auditable record.

## Required content

### Edit 1: refresh status text for `basechange_along_proj_two_inv_derivation` (L51–58 per blueprint reviewer)

Current text:
> "The additive and Leibniz laws closed iter-138; the d_app (zero on
> φ_G-image) and d_map (cross-open naturality) laws remain
> sorry-bodied (iter-140 prover targets)."

Update to iter-143 status:
> "The additive (d_add) and Leibniz (d_mul) laws closed iter-138; the
> d_map (cross-open naturality) law closed iter-142 via the 3-step
> ALIGN_WITH_MATHLIB chase (`pushforward_obj_map_apply'` +
> `NatTrans.naturality_apply` + `relativeDifferentials'_map_d`); the
> d_app (zero on φ_G-image) law remains a sorry-bodied sub-goal (the
> step-3.a categorical equality `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`
> landed iter-143 as a 1-LOC `rw`; the residual 3.b → 3.d chase is
> blocked at the `Pushforward.comp_eq` + `eqToHom` type-coercion
> layer). **DESCOPED iter-145+ under the iter-144 chart-algebra
> pivot**; preserved in-tree as auditable record of the bundled route."

### Edit 2: refresh status text for `basechange_along_proj_two_inv` (L59–69 per blueprint reviewer)

Current text:
> "IsIso of this morphism is the third concrete iter-140 sub-sorry
> (Route (b'2) per iter-139 analogist verdict in
> `analogies/isiso-basechange-along-proj-two-inv.md`)."

Update to iter-143 status (the IsIso obligation moved from an in-line
sorry into a NEW named theorem; see Edit 3 below):
> "The IsIso obligation was extracted iter-143 (Wave 2 refactor;
> `refactor-isiso-extract-iter143`) into a new top-level named theorem
> `basechange_along_proj_two_inv_app_isIso` (see next item) to satisfy
> the iter-143 STRATEGY.md Edit 1 sorry-must-be-named-declaration
> discipline. The consuming `relativeDifferentialsPresheaf_basechange_along_proj_two`
> declaration now invokes the named theorem via `isIso_of_app_iso_module`
> rather than an inline `(fun _ => sorry)`. **DESCOPED iter-145+ under
> the iter-144 chart-algebra pivot**."

### Edit 3: ADD the NEW iter-143 declaration `basechange_along_proj_two_inv_app_isIso`

The pointer chapter's `\itemize` list of in-file Lean declarations is
missing the iter-143 NEW theorem. Add a new `\item` block:

```latex
\item \texttt{AlgebraicGeometry.GrpObj.basechange\_along\_proj\_two\_inv\_app\_isIso}
      --- per-open IsIso obligation extracted iter-143 (Wave 2 refactor)
      from a `letI := ... (fun \_ => sorry)` pattern inside
      \texttt{relativeDifferentialsPresheaf\_basechange\_along\_proj\_two}.
      Body is \texttt{sorry}; the closure recipe is Route (b'2)
      items 2--4 documented at \texttt{RigidityKbar.tex}
      (\cref{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}; the
      first-class blueprint block added iter-144 by the
      \texttt{blueprint-writer-rigiditykbar-iter144} dispatch).
      \textbf{DESCOPED iter-145+ under the iter-144 chart-algebra
      pivot}; preserved as auditable record.
```

The exact insertion point is alphabetically / structurally between the
existing entries for `basechange_along_proj_two_inv` and
`relativeDifferentialsPresheaf_basechange_along_proj_two`. If the
existing items are ordered by line number rather than name, insert
where the corresponding Lean declaration L745 falls.

### Edit 4: refresh status text for `mulRight_globalises_cotangent` (L74–79 per blueprint reviewer)

Current text mentions "iter-134+ prover-lane target". Refresh to:
> "Iter-145+ DESCOPED under the iter-144 chart-algebra pivot; the
> bundled-route Main composition target is no longer on the
> M2.body-pile critical path. Body remains `sorry` as auditable record;
> the chart-algebra route bypasses the global shear-iso globalisation
> entirely via per-chart `Algebra.IsPushout` + per-chart Kähler
> derivation."

### Edit 5 (optional cleanup): chapter introduction prose

If the chapter's introduction (typically L1–20) describes the file's
purpose, consider adding a one-line iter-144 disposition note:

> "**Iter-144 chart-algebra pivot disposition**: the bundled-route
> closure path (pieces (i.b)+(i.c) via global shear-iso globalisation +
> sheaf-of-modules base-change) is DESCOPED iter-145+; this file's
> remaining sorries are preserved as auditable record. Iter-145+
> M2.body-pile prover work targets the chart-algebra route, primarily
> living in a new piece (ii) inflation (see `RigidityKbar.tex`
> § "Piece (ii)" iter-144 chart-algebra envelope)."

## References

- STRATEGY.md § "Iter-144 chart-algebra pivot — COMMITTED" near
  L601–625 — the pivot disposition (what's descoped vs in-tree-as-
  auditable-record).
- `analogies/chart-algebra-vs-bundled-iter144.md` (iter-144 chart-algebra
  analogist's persistent file).
- `RigidityKbar.tex` § Edit 1 + Edit 3 (this iter, via
  `blueprint-writer-rigiditykbar-iter144` dispatch) for the iter-143
  NEW IsIso block's first-class label + the chart-algebra pivot NOTE
  block.

## Out of scope

- **DO NOT add or remove `\leanok` / `\mathlibok` markers anywhere.**
- **DO NOT touch `Jacobian.tex` / `RigidityKbar.tex` / any chapter
  other than `AlgebraicJacobian_Cotangent_GrpObj.tex`.** Those have
  separate writer dispatches.
- **DO NOT modify the underlying Lean file.** This is a blueprint-only
  pass.
- **DO NOT propose strategy changes.** Iter-144 strategy is committed
  in STRATEGY.md; this writer reflects it.
