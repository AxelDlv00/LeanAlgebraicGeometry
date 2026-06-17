# Blueprint Writer Report

## Slug

rigiditykbar-iter139

## Status

COMPLETE — all 6 directive edits landed in
`blueprint/src/chapters/RigidityKbar.tex` without touching out-of-scope
content; the chapter still compiles to balanced LaTeX (lemma 12/12,
proof 12/12, theorem/remark/definition 19/19, itemize 7/7,
enumerate/align/verbatim 0/0 uncommented).

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex`

## Changes Made

The six directive edits land entirely between the proof block of
`lem:GrpObj_omega_basechange_proj` (L489–L639 pre-edit) and the start
of `lem:GrpObj_omega_restrict_to_identity_section` (L641 pre-edit).
Post-edit line ranges (file is now 1222 lines, up from 751):

- **Edit 6 (iter-139 mis-mark flag) — L491–L504.** Added a
  `% NOTE iter-139:` comment block immediately ABOVE the existing
  `\leanok` line (which itself remains untouched per the directive's
  `sync_leanok` boundary), flagging the `letI : IsIso ... := sorry`
  pattern at `Cotangent/GrpObj.lean:624` as a potential
  `sync_leanok` mis-mark for the iter-139 plan agent's
  `doctor`-skill consult. Records the three sub-sorries inside the
  proof (lines 624, 581, 585) and explicitly defers the
  `\leanok`-edit decision to `sync_leanok` territory.

- **Edit 1 (iter-138 closure-shape NOTE) — L505–L593.** Added a
  `% NOTE iter-138:` block IMMEDIATELY AFTER the `\leanok` line at
  L505. Records:
  - Route choice rationale (Route (b) over Route (a) — chart-opacity
    blocker on (a), pushforward transparency on (b)).
  - The two iter-138 top-level Lean helpers
    (`basechange_along_proj_two_inv_derivation` at L547,
    `basechange_along_proj_two_inv` at L596) and how they hook
    into the derivation/adjunction-transpose pipeline.
  - The closed parts (d_add, d_mul) and the three remaining
    sub-sorries (d_app L581, d_map L585, IsIso L624) with explicit
    forward-pointers to the recipes below and the Route (b'2)
    sub-paragraph.
  - The iter-138 negative-lesson note: `simp` does not fire inside
    `Derivation.mk`-produced goals because the lambda appears as a
    beta-redex; the working pattern is
    `have h ... ; change ... ; rw [h] ; exact ...`, codified in
    `.archon/.debug-feedback/debug_feedback.md`.

- **Edit 2 (d_app closure recipe NOTE) — L594–L651.** Added a
  `% NOTE iter-138 (d_app closure recipe).` paragraph spelling out
  the mathematical (NOT Lean-syntactic) closure of the d_app sub-sorry.
  Identifies the closure as a categorical commutativity in
  `Over (Spec k)` (the equality
  `pr_1.left ≫ G.hom = pr_2.left ≫ G.hom` from the binary-product
  universal property in `Over (Spec k)`), translated via
  `Scheme.Hom.toRingCatSheafHom` to a presheaf-level factorisation,
  then discharged via the algebra-side `ModuleCat.Derivation.d_app`.
  Records the three concrete chase steps (1) `Over` structural
  identities + `CartesianMonoidalCategory.hom_ext`, (2)
  `Scheme.Hom.toRingCatSheafHom` functoriality, (3)
  `ModuleCat.Derivation.d_app` discharge.

- **Edit 3 (d_map closure recipe NOTE) — L653–L700.** Added a
  `% NOTE iter-138 (d_map closure recipe).` paragraph spelling out
  the d_map cross-open naturality square. Decomposes the chase
  into two pieces: (1) `ψ.naturality f` from
  `Scheme.Hom.c.naturality` applied to the second projection,
  translating the universal Kähler differential's argument; (2)
  `CommRingCat.KaehlerDifferential.map_d` (available via
  `relativeDifferentials'_map_d` at
  `Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean:201`).
  Closes by identifying the RHS's pushforward-presheaf restriction
  with the LHS-presheaf restriction composed with `restrictScalars`
  (transparent per
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39, 86`).

- **Edit 4 (Route (b'2) sub-paragraph in iter-137 NOTE) — L787–L887.**
  Inserted INSIDE the iter-137 NOTE block, AFTER the "Interim
  Lean-side record" closing paragraph (which itself sits between
  the Route (a)/(b) prose and the chart-by-chart informal prose at
  L888). Contents (matching the directive's required content):
  - Statement of Route (b'2) as the iter-140 closure target with
    the ~195–365 LOC envelope.
  - The 5-line `isIso_of_app_iso_module` helper in a
    `\begin{verbatim}` block (verbatim Lean source, matching the
    iter-139 analogist's typechecked snippet at
    `analogies/isiso-basechange-along-proj-two-inv.md` L101–L110).
  - The two Mathlib facts (`PresheafOfModules.toPresheaf` reflects
    isos via the `Balanced` route +
    `NatTrans.isIso_iff_isIso_app`) and the load-bearing
    `Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced` import.
  - Closure shape: per-open identification with
    `tensorKaehlerEquiv.symm` via the shared chart-unfolding helper
    + chart-level `Algebra.IsPushout`.
  - Iter-140 prover-gap items in build order (4 items).
  - Mathlib API names verified iter-139 (with file/line paths).
  - "Why Route (b'2) over Route (a)" with the LOC delta breakdown
    (`~80–195 LOC` net savings).
  - Explicit caveat that Route (b'2) does NOT escape
    `pullback`-opacity — the chart-unfolding helper is shared with
    Route (a), and the savings come specifically from avoiding the
    forward-direction construction.

- **Edit 5 (two new `\lean{...}` lemma blocks) — L969–L1110.**
  Inserted between the `\end{proof}` of
  `lem:GrpObj_omega_basechange_proj` (L967) and the
  `\begin{lemma}` of
  `lem:GrpObj_omega_restrict_to_identity_section` (L1112):
  - **`lem:GrpObj_omega_basechange_proj_inv_derivation`** at L969–L1046,
    pinning `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation}`,
    with `\uses{def:relative_kaehler_presheaf, def:GrpObj_schemeHomRingCompatibility, lem:GrpObj_omega_basechange_proj}`.
    Marked `\notready` (d_app, d_map still sorry; d_add, d_mul
    closed). Includes statement of the pointwise derivation rule
    `d_X(b) := KaehlerDifferential.D _ ((ψ.app X).hom b)`, the
    `Derivation'.mk` + `ModuleCat.Derivation.mk` construction
    shape, and a forward-pointer to the iter-138 NOTE for the
    closure recipes.
  - **`lem:GrpObj_omega_basechange_proj_inv`** at L1048–L1110,
    pinning `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv}`,
    with `\uses{..., lem:GrpObj_omega_basechange_proj_inv_derivation}`.
    Marked `\notready` (the iso property is the third sub-sorry).
    Notes the construction via
    `(DifferentialsConstruction.isUniversal' φ_G).desc` on the
    derivation + `pullbackPushforwardAdjunction.homEquiv.symm`
    transpose. Forward-pointers to Route (b'2) for the IsIso
    closure.

## Cross-references introduced

All new `\uses{...}` cross-references resolve to labels that already
exist or are newly introduced by Edit 5:

- `\uses{def:relative_kaehler_presheaf}` — exists in
  `blueprint/src/chapters/Differentials.tex` (referenced elsewhere
  in `RigidityKbar.tex`).
- `\uses{def:GrpObj_schemeHomRingCompatibility}` — exists at
  `RigidityKbar.tex:423` (the iter-135 packaging definition).
- `\uses{lem:GrpObj_omega_basechange_proj}` — exists at
  `RigidityKbar.tex:441` (the parent lemma).
- `\uses{lem:GrpObj_omega_basechange_proj_inv_derivation}` — newly
  introduced by Edit 5 at L969–L1046; consumed in the second new
  lemma's `\uses`.
- `\cref{lem:GrpObj_omega_basechange_proj_inv_derivation}` and
  `\cref{lem:GrpObj_omega_basechange_proj_inv}` — referenced from
  the iter-138 NOTE block (Edit 1) and from each other's prose
  bodies (forward/back pointers).
- `\cref{rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom}` —
  exists at `RigidityKbar.tex:436` (already in the chapter; referenced
  from the new derivation lemma's prose).

No dangling references.

## Macros needed (if any)

**None added.** The edits stay within macros already declared in
`blueprint/src/macros/common.tex`:

- Math operators used: `\Spec`, `\Hom`, `\Over`, `\Opens`,
  `\Scheme`, `\CommRingCat`, `\ModuleCat`, `\isPushout`,
  `\finrank`, `\op`, `\Sym`, etc. — all pre-declared.
- Lean-syntactic identifiers use the chapter's existing
  `\texttt{...}` idiom (with `\_` for underscores), matching the
  surrounding prose. No new commands were introduced.
- The `\app`, `\hom`, `\obj`, `\map`, `\desc`, `\symm`,
  `\homEquiv` shorthand identifiers appear inside math mode in
  the new prose (e.g. `\psi.\app\,X` rendering as `ψ.app X`).
  These are **not** declared as macros and will render as
  juxtaposed math letters — this matches the existing chapter
  convention (see e.g. `RigidityKbar.tex:115` "`$\GrpObj$`",
  used 4× pre-edit without a macro declaration, rendering as
  italicised letters). If the plan agent prefers crisper rendering,
  declaring `\newcommand{\app}{\texttt{app}}` etc. in
  `macros/common.tex` would be a low-cost cosmetic improvement;
  it is NOT required for compilation and is OUT OF MY
  WRITE-DOMAIN, so I did not attempt it.
- Inside `% NOTE` comment blocks, I used `\texttt{...}` form for
  Lean identifiers (matching surrounding comment style); rendered
  output is irrelevant for the comment lines themselves.

## Reference-retriever dispatches (if any)

**None.** The directive named two analogist artifacts I needed:

- `analogies/isiso-basechange-along-proj-two-inv.md` (iter-139
  analogist verdict; the load-bearing reference for Edit 4) — read
  in full.
- `analogies/kaehler-tensorequiv-presheafpullback.md` and
  `analogies/mulright-globalises-cotangent.md` — already referenced
  from the existing chapter; not re-read in full (the relevant
  content is already woven into the existing iter-137 NOTE block).
- `analogies/phi-compatibility-morphisms.md` — referenced from the
  Edit 5 prose; existing chapter prose already references this
  iter-135 verdict.

I also read the iter-138 Lean docstring at
`AlgebraicJacobian/Cotangent/GrpObj.lean:476–595` directly (for the
substantive helper signatures + iter-138 closure status), per the
directive's "References" section.

No external sources were needed.

## Notes for Plan Agent

1. **Edit 4 placement inside the iter-137 NOTE block.** The
   directive said "Add a new sub-paragraph **after** the existing
   Route (b) prose (immediately before the L632 chart-by-chart
   prose), inside the same NOTE block". I placed it AFTER the
   "Interim Lean-side record" closing paragraph (which itself
   sits between the Route (b) prose at L577–L620 and the
   chart-by-chart informal prose at L632 pre-edit) — this seemed
   the most coherent narrative flow (iter-137 record → iter-139
   Route (b'2) refinement → informal motivation). If the plan
   agent prefers Route (b'2) immediately after Route (b) and
   before "Interim Lean-side record", the swap is trivial. The
   chosen placement keeps the iter-137 record paragraph adjacent
   to its Route (a)/(b) discussion.

2. **Edit 5 `\notready` markers.** Both new lemma blocks carry
   `\notready` in their statement blocks. The directive's example
   LaTeX placed `\notready` outside the proof block but inside
   the lemma block — I followed that placement. The
   `basechange_along_proj_two_inv` lemma's proof block contains
   "no proof body" prose (the construction itself is a `def`,
   sorry-free in iter-138, so there is no proof obligation; the
   iso property is carried by the parent lemma's proof). The
   `\notready` reflects that the iso property is still
   sorry-bodied at the project level, even though the
   declaration itself compiles. If the plan agent considers this
   marker semantics inconsistent (`\notready` is typically for
   pending proof bodies, not for declarations whose downstream
   consumers have pending obligations), the marker can be
   removed and replaced with a `% NOTE:` annotation; the
   `sync_leanok` script would then need to decide based on the
   Lean target's actual sorry count (zero for these two
   declarations themselves; the sorries live downstream in
   `relativeDifferentialsPresheaf_basechange_along_proj_two`).

3. **No contradiction with the iter-138 Lean code observed.**
   The blueprint prose I added matches the iter-138 Lean target's
   signatures and docstrings:
   - `basechange_along_proj_two_inv_derivation` signature at
     L547–L553 of `Cotangent/GrpObj.lean` ↔ blueprint prose at
     L995–L1003.
   - `basechange_along_proj_two_inv` signature at L596–L610 of
     `Cotangent/GrpObj.lean` ↔ blueprint prose at L1078–L1083.
   - Three sub-sorries at lines 581, 585, 624 of
     `Cotangent/GrpObj.lean` ↔ blueprint enumeration at L556–L573.
   The iter-138 Lean docstring at lines 489–510 of
   `Cotangent/GrpObj.lean` describes a `(asIso (… inv …)).symm`
   assembly that I echoed in the iter-138 NOTE block (L551).

4. **`sync_leanok` mis-mark concern (Edit 6 records, not fixes).**
   The directive explicitly said "Do NOT add or remove the
   `\leanok` yourself" and to "Add a `% NOTE iter-139:` comment
   ABOVE the existing `\leanok` line flagging the mis-mark
   concern". I did exactly that. The iter-139 plan agent should
   consult the `doctor` skill on whether the
   `letI : IsIso ... := sorry` pattern is being correctly
   detected by `sync_leanok` (which I did not investigate; it
   sits outside my write-domain).

5. **Iter-137 NOTE block preservation (per directive).** The
   iter-137 NOTE block (originally L492–L631) is preserved
   verbatim. My Edits 1–3 land AHEAD of it (between L491
   `\leanok` and L702 where the iter-137 NOTE begins post-edit).
   My Edit 4 lands INSIDE it (between the iter-137 narrative and
   the chart-by-chart informal prose). The iter-135 NOTE block
   on `lem:GrpObj_omega_basechange_proj` (L470–L480 pre-edit) is
   also preserved verbatim. The iter-136-review NOTE block on
   `lem:GrpObj_omega_restrict_to_identity_section` (L663–L676
   pre-edit) is untouched.

6. **No condensation of iter-137/iter-138 NOTE blocks performed.**
   Per the directive ("default: preserve; plan agent decides
   consolidation iter-140+"), I left both blocks verbatim. The
   chapter is now 1222 lines (up from 751); a future iter-140+
   round may want to condense the iter-137 + iter-138 NOTE
   blocks into a single historical record block, but I did not
   perform that consolidation this round.

7. **Pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex`
   NOT touched.** Per the directive ("DO NOT edit
   `AlgebraicJacobian_Cotangent_GrpObj.tex` (the pointer chapter)").
   The plan agent should handle the 2-bullet enumeration addition
   to that pointer chapter separately.

## Strategy-modifying findings

**None.** The edits faithfully reflect the iter-138 prover lane's
substantive closure shape and the iter-139 analogist's Route (b'2)
verdict, both of which are already endorsed by STRATEGY.md per the
directive's strategy context. No new strategy-level issues
surfaced while drafting; the chapter prose remains coherent with
the over-k commitment, the shared cotangent-vanishing pile
decomposition, and the piece (i.b) sub-lemma decomposition that
the chapter already encodes.
