# Blueprint Writer Report

## Slug
ts216c

## Status
COMPLETE — all three directive items applied; one correctness caveat in the
directive's own rationale was found against the Mathlib source and resolved by
taking the directive-permitted "contrast" framing (see Strategy-modifying findings).

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### Item 1 — CORRECTNESS FIX of the `monoidOfSkeletalMonoidal` / `Skeleton` mis-citation
Applied consistently at the three places the chapter framed the group law as "à la
`Skeleton`":

- **Revised `lem:tensorobj_isoclass_commgroup` source block** (was a bare
  `\textit{Source: ... built as Units(Skeleton(ModuleCat R))}`). Replaced with an
  accurate `% SOURCE:` + verbatim `% SOURCE QUOTE:` from
  `Mathlib/RingTheory/PicardGroup.lean` (L28–L44, opened this session) plus a
  reframed `\textit{Source: ...}`: this is an Archon-original **by-hand** packaging;
  the fixed-ring precedent `CommRing.Pic R := Skeleton(Module.Invertible R)` reads its
  `CommGroup` off the `Skeleton` of the coherent `MonoidalCategory(Module.Invertible R)`
  Mathlib supplies over a fixed ring, and the present construction does **not** take
  that route because the coherent `MonoidalCategory` on `X.Modules` it would need is
  exactly what is unavailable for the varying structure sheaf.
- **Revised `lem:tensorobj_isoclass_commgroup` proof tail** — removed "à la
  `monoidOfSkeletalMonoidal` / `Skeleton` … specialized to the ⊗-invertible classes".
  Now states the four group-axiom fields (`mul_assoc`, `one_mul`/`mul_one`,
  `mul_comm`, inverse) are each defined directly from a single existence-of-iso, and
  explicitly that we do **not** go through `CategoryTheory.monoidOfSkeletalMonoidal` /
  `Skeleton` because those require a coherent `[MonoidalCategory]` (and
  `[BraidedCategory]`) on the carrier — the very structure on `X.Modules` this
  construction avoids — kept only as a contrast.
- **Revised motivation passage (§ motivation, ~L116–122)** — was "exactly as Mathlib
  builds `CommRing.Pic` as `Units(Skeleton(ModuleCat R))`". Reframed to by-hand
  assembly with the accurate `Skeleton(Module.Invertible R)` contrast.
- **Revised off-path remark `rem:scheme_modules_monoidal_off_path` (~L409–414)** — was
  "This mirrors Mathlib's own `CommRing.Pic` … transported from
  `Units(Skeleton(ModuleCat R))`". Reframed: same carrier (scheme analogue of
  `CommRing.Pic`), but the two are built differently — Mathlib via `Skeleton` of the
  coherent monoidal `Module.Invertible R`, here by hand because that coherent monoidal
  category is unavailable.

### Item 2 — FREE-COVER make-or-break (added to both `lem:tensorobj_assoc_iso` and `lem:tensorobj_restrict_iso`)
- **`lem:tensorobj_assoc_iso`** — added an `\emph{The free-cover make-or-break.}`
  paragraph after the lemma: the group law consumes the associator only for
  locally-trivial (line) bundles, the gluing cover trivialises them to **free**
  modules, and on a free cover the restriction-compatibility `lem:tensorobj_restrict_iso`
  reduces to the elementary base-change of free modules along the open immersion
  (sheaf-⊗ = presheaf-⊗ on free pieces), needing **no** general presheaf-pushforward
  adjunction. States the PRIMARY obligation = restriction-compatibility on the free
  cover without H1; fallback = if it forces H1, no size reduction, revert to comparing
  against route-(e) `(J.W).IsMonoidal → Sheaf.monoidalCategory` (`lem:jw_ismonoidal`).
- **`lem:tensorobj_restrict_iso`** — added an
  `\emph{The make-or-break: only the free-cover case is on the critical path.}`
  paragraph to the proof's closing: the arbitrary-module statement carries the H1
  residual, but the associator consumes it only on the trivialising free cover, where
  it follows from `lem:restrictscalars_ringiso_tensorequiv` alone (base change along
  the structure-sheaf ring iso `f.appIso`), no H1. PRIMARY obligation = free-cover
  specialisation without H1; same route-(e) fallback noted. `lem:restrictscalars_ringiso_tensorequiv`
  left untouched as required.

### Item 3 — route-(e) demotion completion
- **Revised `sec:tensorobj_onproduct_lift` intro (~L427)** — removed the live-source
  framing "under route~(e) these are read off the `MonoidalCategory` structure of
  `lem:jw_ismonoidal`". Now: the existence facts are supplied **directly** (assoc by
  gluing via `restrict_iso`, unit/comm by `mapIso`, inverse by ⊗-invertibility), and
  the route deriving them from `lem:jw_ismonoidal` is superseded/off-path. Also fixed
  the contradictory final sentence: `lem:tensorobj_restrict_iso` is on the critical
  path because it is consumed by the direct-gluing associator
  `lem:tensorobj_assoc_iso`, **not** by the off-path `lem:islocallyinjective_whisker_of_W`.
- **`lem:jw_ismonoidal` block + surrounding prose** — already carries strong
  supersession banners from a prior pass ("Superseded route --- off path, not to be
  formalized", lemma title "(route~(e) target)", "stated-but-unformalized"). No live
  promotion remained, so it was left as-is; the `lem:jw_ismonoidal` label is intact
  and resolvable.
- **Chapter-closing internal-consistency summary (`sec:tensorobj_consistency_check`)** —
  one item still framed the coherence isomorphisms as "components of the route~(e)
  monoidal structure `lem:jw_ismonoidal`", which promoted route-(e) as their live
  source. **Edited**: now "supplied **directly**, **not** read off the route~(e)
  monoidal structure `lem:jw_ismonoidal` (superseded / off-path fallback only)" —
  unitors/braiding by `sheafification.mapIso`, associator glued through
  `lem:tensorobj_restrict_iso`. The `lem:jw_ismonoidal` `\cref` is preserved.
- **Also cleaned two casual route-(e)-promoting asides** in the superseded
  `sec:tensorobj_route_e` blocks (L872, L1175) that read "mirroring / à la Mathlib's
  `monoidOfSkeletalMonoidal`" — reframed to "built by hand … not off a coherent
  monoidal category's `Skeleton`", consistent with the corrected item-1 framing.

### Post-batch correction note
My first edit batch reconstructed several `old_string`s from a partial first read of
this 2k-line file; five of seven did not match the on-disk text and were no-ops (no
fabricated content landed). I re-read each exact target fresh and re-applied all
edits faithfully. Final on-disk audit confirms every OLD mis-citation phrase removed
and every required NEW phrase present; `monoidOfSkeletalMonoidal` now appears exactly
twice, both in deliberate "we do **not** use this" contrast clauses.

## Cross-references introduced
- No new `\uses{}` edges. New prose references existing labels
  (`lem:tensorobj_assoc_iso`, `lem:tensorobj_restrict_iso`,
  `lem:restrictscalars_ringiso_tensorequiv`, `lem:tensorobj_unit_iso`,
  `lem:tensorobj_comm_iso`, `lem:jw_ismonoidal`,
  `lem:islocallyinjective_whisker_of_W`, `def:scheme_modules_isinvertible`) — all
  present in this chapter.

## References consulted
- `.lake/packages/mathlib/Mathlib/RingTheory/PicardGroup.lean` (L1–L44) — verbatim
  source for the corrected `CommRing.Pic` / `Module.Invertible` / `CommGroup (Pic R)`
  citation in `lem:tensorobj_isoclass_commgroup`. This is the file that revealed the
  directive's rationale error (see below).

## Macros needed (if any)
- None. Used only existing macros (`\Scheme`, `\MonoidalCategory`, `\Spec`, `\mathtt`,
  `\cref`). `\MonoidalCategory` was already in use in the chapter.

## Notes for Plan Agent
- The directive's item 1 said to cite `CommRing.Pic` / `instCommGroupPic` as a
  precedent that "builds a `CommGroup` directly on `Module.Invertible` iso-classes
  WITHOUT constructing a monoidal category." **The Mathlib source contradicts this.**
  `Mathlib/RingTheory/PicardGroup.lean` defines
  `CommRing.Pic R := Skeleton (Module.Invertible R)` with
  `instance : CommGroup (Pic R) := inferInstanceAs <| CommGroup <| Skeleton _`, and it
  **does** build `instance : MonoidalCategory (Module.Invertible R)` (L42–44). So
  `CommRing.Pic` is itself the `Skeleton`/`monoidOfSkeletalMonoidal` route over a fixed
  ring; it does construct a (coherent, monoidal) category and take its `Skeleton`.
- The directive's deeper, **correct** point still holds: this chapter's construction
  CANNOT be "à la `Skeleton`" because `Skeleton`/`monoidOfSkeletalMonoidal` require a
  coherent `MonoidalCategory` on the carrier — here `X.Modules` for the *varying*
  structure sheaf — which is exactly what the chapter avoids. I therefore took the
  directive's explicitly-permitted alternative ("keep it ONLY as a contrast: we do not
  use `Skeleton`, which would require the coherent `MonoidalCategory (X.Modules)`").
  This is both directive-permitted and faithful to the source. I did **not** write the
  source-contradicting claim that `CommRing.Pic` avoids a monoidal category.
- There is no `instCommGroupPic` declaration by that name in the file; the instance is
  the anonymous `instance : CommGroup (Pic R)`. I cited it by its actual form.
- The garbled line-numbering seen while reading (duplicated headers around the
  commgroup lemma) was a Read-display artifact; a clean re-read confirmed the LaTeX is
  well-formed (stub `commgroup_intro` lemma + the real `commgroup` lemma, no duplicate
  optional-arg brackets).

## Strategy-modifying findings
- Minor / citation-level, not strategy-level: the precedent `CommRing.Pic` is **not**
  an instance of the by-hand-without-a-monoidal-category pattern (it is the
  `Skeleton`-of-a-monoidal-category pattern). The chapter's strategy — build the
  `CommGroup` by hand from three existence-of-iso facts because no coherent
  `MonoidalCategory (X.Modules)` is available — is unaffected and is, if anything,
  sharpened by the contrast. No STRATEGY.md change is required, but the plan agent
  should not re-introduce the "CommRing.Pic builds a group without a monoidal
  category" phrasing in future directives.
