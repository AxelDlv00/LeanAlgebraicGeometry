# Blueprint Writer Report

## Slug
bw253

## Status
COMPLETE — all three FIXes applied plus the optional polish; no markers touched.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### FIX 1 (MUST-FIX) — D1′ fourth-square proof sketch corrected
- **Revised** proof of `lem:pullback_tensor_map_natural`
  (`\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}`). Replaced the
  whisker-exchange paragraph with the **section-level descent** route that actually
  compiles:
  - States explicitly that the fourth square is the one square *not* closed by the
    monoidal interchange (whisker-exchange) law, and *why* — the η-whiskers and the
    tensor-of-morphisms factors are framed by two monoidal structures on
    `PresheafOfModules` that agree definitionally but not syntactically, and the
    interchange law fires only within a single framing.
  - Describes the working route: descend via `PresheafOfModules.Hom.ext` to components
    over each open `U`; distribute legs into concrete `ModuleCat`-maps (noting the two
    carrier spellings `Sheaf.val` vs `_ ∘ forget₂ CommRingCat RingCat` are
    "definitionally but not syntactically equal", hence definitional-keyed rewriting);
    after `ModuleCat.hom_ext` the goal is an instance-free element-level identity on
    `(M ⊗_X N).obj U`, closed by `TensorProduct` induction.
  - Gives the pure-tensor residual as the bilinear sectionwise naturality of η in each
    argument (displayed both component equations for `p` and `q`).
  - Old `% NOTE (iter-252)` folded into prose and trimmed to a short `% NOTE (iter-253)`
    pointer to the two helper labels.

### FIX 2 — `\lean{}` pins added (three substantive helpers)
- **Added lemma** `lem:sheafify_tensor_unit_iso_natural`
  (`\lean{AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural}`) — the
  section-level naturality helper carrying the open D1′ fourth-square residual. Placed
  immediately after the D1′ proof.
- **Added lemma** `lem:pullback_val_iso_natural`
  (`\lean{AlgebraicGeometry.Scheme.Modules.pullbackValIso_hom_natural}`) — the closed
  naturality helper that is a (closed) input square to the D1′ pasting. Placed after the
  previous stub.
- **Added lemma** `lem:scheme_modules_hom_local_section`
  (`\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}`) — the load-bearing
  `localSection` sub-lemma, placed immediately before `lem:sheafofmodules_hom_of_local_compat`.
  In the `homOfLocalCompat` proof prose, added a `\cref{lem:scheme_modules_hom_local_section}`
  at the principal mention of the local section (kept the readable `\mathtt{localSection}`
  shorthand for subsequent in-proof references).

### FIX 3 (MAJOR) — HEq → IsCompatible bridge expanded
- **Revised** proof of `lem:sheafofmodules_hom_of_local_compat`, sub-step (a). Promoted
  (a) from "mechanical" to a spelled-out recipe:
  - Explains `hf` is stated with `HEq` because the two double-restrictions reach the
    overlap by two slice-restriction routes living in propositionally-but-not-definitionally
    equal types.
  - Contrasts with what `IsCompatible H.1 U (homLocalSection U f)` actually asks (honest
    equality of the two `localSection` restrictions as sections of `H` over `U_i ⊓ U_j`,
    in the single type `H.1.obj (op (U_i ⊓ U_j))`).
  - Gives the bridge: transport `hf`'s `HEq` through the `eqToHom`-conjugation built into
    `localSection` (app/naturality fields, cross-referencing the new
    `lem:scheme_modules_hom_local_section`); the route-difference between the two
    restriction maps collapses via `Subsingleton.elim` on parallel morphisms in the thin
    poset `(Opens X)ᵒᵖ`, turning the `HEq` into the required genuine equality.
  - Sub-steps (b), (c), (d) kept as-is (relabelled "the other three sub-steps are
    mechanical").
  - Old `% NOTE (iter-252)` at the load-bearing-datum paragraph folded into prose and
    trimmed to a short `% NOTE (iter-253)` pointer.

### Optional polish (MINOR) — `lem:dual_unit_iso`
- **Revised** proof prose: removed the "composed with the left unitor
  `lem:tensorobj_unit_iso`" phrasing and replaced it with the direct evaluation-at-1 /
  global-scalar-multiplication isomorphism (matching the Lean `unitDualSectionEquiv` /
  `globalSMul`-inverse route), with a one-line parenthetical that no left unitor is needed.
  Dropped `lem:tensorobj_unit_iso` from the **proof** `\uses{}`. (Left the statement-block
  `\uses{}` untouched — directive only flagged the proof `\uses`.)

## Cross-references introduced
- D1′ proof `\uses{}` extended with `lem:sheafify_tensor_unit_iso_natural,
  lem:pullback_val_iso_natural` (both newly defined in this chapter — verified present).
- `lem:scheme_modules_hom_local_section` `\uses{lem:open_immersion_slice_sheaf_equiv}`
  (exists in this chapter).
- `\cref{lem:scheme_modules_hom_local_section}` added in the `homOfLocalCompat` proof and
  in the expanded sub-step (a).
- The two new D1′ helper stubs do NOT `\uses` their parent (avoids a dependency-graph
  cycle); the parent proof `\uses` them, which is the correct direction.

## Markers
No `\leanok` / `\mathlibok` markers were added, removed, or modified. The three new lemma
blocks carry no markers (sync_leanok / review own those). Only prose, `\lean{}` pins (via
new blocks), `\uses{}` edits, `\cref{}` additions, and NOTE-trimming were performed.

## References consulted
None — all three FIXes are Archon-bespoke formalization-engineering corrections
(carrier-friction routing, gluing bookkeeping) with no new external source claim. No
`% SOURCE:` / `% SOURCE QUOTE:` lines were added. Existing source citations left as-is. No
reference-retriever dispatched.

## LaTeX validity
Environment nesting checked: real (non-comment) `\begin`/`\end` pairs balance. A parser
off-by-one is a pre-existing false positive — the `% SOURCE QUOTE:` block of
`lem:tensorobj_inverse_invertible` (line ~1632) contains a commented-out `% \begin{lemma}`
with no in-comment close; it is inside LaTeX comments and unrelated to this round's edits.

## Notes for Plan Agent
- The two new D1′ helper stubs (`lem:sheafify_tensor_unit_iso_natural`,
  `lem:pullback_val_iso_natural`) and `lem:scheme_modules_hom_local_section` are
  statement-only blocks with `\lean{}` pins; `sync_leanok` should mark them appropriately
  next phase (the first carries an open sorry in Lean; the latter two are closed
  axiom-clean per the checker reports).

## Strategy-modifying findings
None.
