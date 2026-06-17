# DAG Walker Report

## Slug
picard-substrate

## Seed
lem:isinvertible_implies_locallytrivial

## Status
COMPLETE — every directive target pinned and (where a real consumer exists) wired;
the seed's ancestor cone is now fully effort-0. Two nodes are deliberately left
isolated (no honest consumer) and two carry TODO placeholders (no Lean decl exists);
both are documented below, not gaps.

## KEY STRUCTURAL FINDING (read this first — it governs every edit)
This project's `leandag` builds DAG edges **only from the first statement-level
`\uses{}`** in a node's body. The parser stores the `proof` environment text
(`proof_tex`) but **never scans it for `\uses{}`** — so a dependency declared *only*
inside `\begin{proof} ... \uses{...} ... \end{proof}` produces **no edge**.
(Verified in `leandag/parser.py:157` `_USES_RE.search(body)` — single, statement-only —
and `leandag/dag.py:189` `uses = decl.uses`; `proof_tex` is never re-parsed.)

Consequence: the three "isolated leaves" were isolated **precisely because** their
consuming lemmas cited them in *proof* `\uses{}` (and `\cref{}`) only. The honest fix
is to **merge the dependency into the consumer's statement-level `\uses{}`**, which is
what I did. This also means many other proof-only `\uses{}` across the blueprint are
silently un-edged (e.g. `lem:pullback_tensor_iso_unit`'s proof deps
`lem:isiso_sheafifyeta_of_unitsquare`, `lem:eta_bridge_unit_square`) — out of scope
here, flagged for the dispatcher under Notes.

## Cone before → after
- ∞ holes in cone: 0 → 0  (`leandag show gaps` / `dag-query gaps` was empty project-wide; all finite)
- broken `\uses` touching cone: 0 → 0  (all my `\uses` targets resolve; the single
  project-wide `unknown_use` is `thm:genus_zero_curve_iso_p1 → cor:nonconstant_function_genus_zero`,
  in the Genus chapter — pre-existing, out of scope)
- **Seed `effort_total`: 2261 → 1523** — the entire ancestor cone is now effort-0
  (`lem:stalk_linear_map` 738 → 0 once pinned to its real sorry-free decl). The
  residual 1523 is the seed's own unproved body (the target to prove; not in scope).
- Project-wide isolated nodes: 484 → 455 (29 newly connected)
- `\lean{}` pins added/fixed: 8;  statement-level `\uses` edges added: 6;  conflicts: 0

## Blocks added / proofs written
None. Per directive (transcription + pinning only) no statements/proofs were rewritten.

## `\lean{}` pins added / fixed
In `chapters/Picard_TensorObjSubstrate.tex`:
- `lem:flat_whisker_localizer` → `\lean{PresheafOfModules.W_whiskerLeft_of_flat}` (real, sorry-free; umbrella over `_of_flat` L/R)
- `lem:stalk_linear_map` → `\lean{PresheafOfModules.stalkLinearMap}` (real; umbrella over `stalkLinearMap{,_germ,_bijective_of_isIso}`, `stalkLinearEquivOfIsIso` — pinned to the representative. **This is the seed-cone node**; pinning it dropped its effort 738 → 0)
- `lem:whisker_of_W` → `\lean{PresheafOfModules.W_whiskerLeft_of_W}` (real, sorry-free — despite the "abandoned" prose the decl exists and compiles)
- `lem:islocallyinjective_whisker_of_W` → `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (real). This obligation is the **same statement** as the live `lem:islocallyinjective_whiskerleft_via_stalk` (which already owns this decl) and is realised by it; the two blueprint nodes legitimately share the pin (`leandag` `conflicts` flags only Lean-side name collisions — rebuild shows `conflicts: 0`). Pinning the placeholder instead would have falsely inflated its effort 0 → 6935.
- `lem:isiso_sheafification_map_of_W` → **fixed** `AlgebraicGeometry.TODO.isisoSheafificationMapOfW` → `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (the real decl exists, is sorry-free, and "still backs the current `tensorObj_assoc_iso` proof" per the block's own comment; the TODO was stale)
- `lem:jw_ismonoidal` → `\lean{AlgebraicGeometry.TODO.jw_ismonoidal}` (TODO placeholder, rule 1 — the full `(J.W).IsMonoidal`/`LocalizedMonoidal` route-(e) packaging is stated but deliberately **not** formalized; no decl exists)
- `lem:stalk_tensor_commutation_naturality_right` → `\lean{AlgebraicGeometry.TODO.stalk_tensor_commutation_naturality_right}` (TODO placeholder — the existing iter-238 NOTE records that no standalone decl exists; its content was inlined into `isLocallyInjective_whiskerLeft_of_W`)

In `chapters/Picard_RelPicFunctor.tex`:
- `thm:rel_pic_etale_sheaf_unit_canonical` → `\lean{AlgebraicGeometry.TODO.rel_pic_etale_sheaf_unit_canonical}` (TODO placeholder — forward-looking universal property; `RelPicFunctor.lean` supplies `PicSharp.etSheaf` + `etSheaf_group_structure` but not the universal-property statement)

## `\uses` edges added/fixed (the completeness fixes)
- `lem:pullback_tensor_map_natural` statement now `\uses{... lem:sheafify_tensor_unit_iso_natural, lem:pullback_val_iso_natural}` — both are the Square-3/Square-4 inputs cited only in its proof; **wires the leaf `lem:pullback_val_iso_natural`** (rdep 0 → 1) and its peer.
- `lem:sheafofmodules_hom_of_local_compat` statement now `\uses{def:scheme_modules_homMk, lem:open_immersion_slice_sheaf_equiv}` (previously **no** statement `\uses`; both cited only in its proof) — **wires the leaf `def:scheme_modules_homMk`** (rdep 0 → 1).
- `lem:islocallyinjective_whisker_of_W` statement `\uses` extended with `lem:stalk_linear_map, lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso` (the primary + fallback proof routes' real deps; were proof-only).

`def:scheme_modules_homMk` already carried its own `\lean{}` (L6292) — it was only the
*consumer* edge that was missing; that is now fixed.

## Could not complete (by-design isolated — NOT gaps)
- `lem:isiso_sheafification_map_of_W` — **left rdep 0 (isolated) intentionally.** Its
  only reference anywhere in the blueprint is a `\cref` inside the §`sec:tensorobj_consistency_check`
  *section prose* audit list (≈L5141), not inside any lemma/proof. The block's own text
  states it "depends on no prior block … retained as a supplement (no longer the
  associator's load-bearing step)." There is no consuming block, so no honest `\uses`
  edge can be added without fabricating a false dependency. Pin corrected to the real
  decl; node left honestly standalone.
- `lem:flat_whisker_localizer` — remains rdep 0 by design: explicitly a "closed,
  sorry-free standalone result … off the critical path," superseded by the d.2 route.
  Pinned to its real decl; no consumer to wire.

These two are the directive's only leaves that the leandag graph cannot connect; both
are deliberate standalone supplements, correctly reflected by an incoming-only / no-edge
shape rather than a fabricated consumer.

## References consulted
None newly retrieved. `thm:rel_pic_etale_sheaf_unit_canonical` already carries a complete
`% SOURCE` / `% SOURCE QUOTE` / `\textit{Source: [Kleiman] §2}` citation block (verbatim
from `references/kleiman-picard-src/kleiman-picard.tex`); I added only the `\lean{}` pin
and `\uses{}` edges and did not touch the cited prose.

## Notes for dispatcher
- **leandag edge model (important):** edges come from statement-level `\uses{}` only.
  Proof-level `\uses{}` are inert. If the team wants proof dependencies to count, that
  is a `leandag/parser.py` change (scan `proof_tex` for `\uses{}` and union into
  `decl.uses`). Until then, every prover/blueprint-writer should put load-bearing deps
  on the **statement** `\uses{}`, not (only) inside `\begin{proof}`. Several nodes
  beyond this directive's scope are under-edged for this reason (e.g.
  `lem:pullback_tensor_iso_unit` is missing `lem:isiso_sheafifyeta_of_unitsquare`,
  `lem:eta_bridge_unit_square`).
- **`sync_leanok` follow-up:** `lem:stalk_linear_map`, `lem:whisker_of_W`,
  `lem:flat_whisker_localizer`, `lem:isiso_sheafification_map_of_W`,
  `lem:islocallyinjective_whisker_of_W` now point at real sorry-free decls and report
  effort 0 but `proved=False` (no `\leanok` in the blueprint body yet). The deterministic
  `sync_leanok` phase should add their `\leanok` on its next pass.
- **Stale comment in Lean source:** `TensorObjSubstrate/Vestigial.lean:15` header says
  "`FlatWhisker`/`WhiskerOfW` … one open sorry"; the file has **no** `sorry` (only that
  comment). Worth a cleanup so the header doesn't mislead.
- **Two blueprint nodes share one Lean decl** (`isLocallyInjective_whiskerLeft_of_W`:
  `lem:islocallyinjective_whisker_of_W` obligation + `lem:islocallyinjective_whiskerleft_via_stalk`
  discharge). Intentional and conflict-free; if the team later merges the duplicate
  superseded block, drop the obligation node's pin then.
- Pre-existing broken edge unrelated to this cone: `thm:genus_zero_curve_iso_p1`
  `\uses{cor:nonconstant_function_genus_zero}` (label undefined) — Genus chapter.
