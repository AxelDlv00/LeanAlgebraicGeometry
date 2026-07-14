# Brick spec — Layer 2: the étale-sheafified Picard functor `picEt`

*Written 2026-07-14 (Fable orchestrator), the session (C1) closed. Consumer: one Fable
implementation agent. The design was resolved in inbox I-0140 (run-0027 OPEN-1 analysis)
and `informal/wave3-picard-design.md` §9 — READ BOTH FIRST; they are binding on the
vehicle choice. The gating corollary is now unconditionally available.*

## Mission

**Deliverable contract:**

1. `picEt` — the étale-sheafified relative Picard functor on test objects
   `T : Over (Spec k)`, built as the **bespoke affine-opens limit** over `PicEtAff`
   (I-0140's resolution): sections are compatible families over the affine opens of
   `T.left`, valued in `PicEtAff C Γ(U)`; functoriality along arbitrary `f : T'' ⟶ T` by
   GLUE — evaluate on a finite basic-open cover refining the preimages of affines, glue
   by the sheaf property, choice-independence from separatedness. Both are licensed by
   (C1): `PicEtAff.unit_injective` (committed 5d7be76376, `Picard/CechKernelLemma.lean`)
   makes `PicEtAff` separated on affines, so glued values are unique when they exist.
2. `picEt_affine_iso` — on an affine test, `picEt (overSpec k A) ≅ PicEtAff C A`
   (terminality of `⊤` in the affine-opens poset).
3. Functor laws (`map_id`, `map_comp`) and naturality of the affine comparison.
4. The separatedness/sheaf-uniqueness lemmas for `picEt` itself that (C2) and the
   degree/Pic⁰ interface will consume — package what falls out naturally; the binding
   minimum is uniqueness of gluings (two sections of `picEt T` agreeing on a cover of
   `T` by opens are equal).

Group structure: `PicEtAff C A` is a commutative group and the limit is of groups —
state `picEt` valued in `CommGrp` (or with the group structure as separate instances)
per what the existing `RelPic`/`PicEtAff` layer already does; mirror its conventions.

**Staged fallback:** (1) full contract; (2) `picEt` + `picEt_affine_iso` + `map_id`,
with `map_comp` (the two-cover compatibility) as the recorded frontier; (3) largest
green prefix. Never red, never sorry.

## READ FIRST (binding order)

1. Inbox item `.archon-horizon/inbox/local/items/I-0140.yaml` — the OPEN-1 resolution:
   why the comma-category Ran and the mathlib `Sites/Affine` routes were rejected
   (size/functoriality walls), and the affine-opens-limit + glue design.
2. `informal/wave3-picard-design.md` §9 (OPEN-1) and the Layer-2/file-12 sections it
   references.
3. The landed Layer-1 API: `Picard/PicEtAff.lean` (`unit`, `mk_eq_mk_iff`,
   `descentClasses`), `Picard/PicEtAffMap.lean` (`map`/`mapAlg` functoriality + unit
   naturality + functor laws), `Picard/RelPic.lean`, and the (C1) exports in
   `Picard/CechKernelLemma.lean` (`PicEtAff.unit_injective`,
   `Over.exists_cechPic_map_snd_of_ker_whiskerLeft`).
4. `Picard/EtaleSeparatedness.lean` + `Picard/Separatedness.lean` — ζ1 and
   `prPullback_injective` (arbitrary `T` — no affineness needed; this is what makes the
   glue-based functoriality check work on general tests).

## Design constraints (binding)

- The kernel discipline of this session's bricks (recorded in
  `informal/spec-zeta3-close.md` and the ζ3 engineering notes in the task comments):
  opaque `def`s for repeated data; abstract lemmas instantiated once for anything
  rewrite-heavy; no `rw`/`simp only ... at` over concrete-tower hypotheses; explicit
  higher-order arguments (HO-unification sticks on projections of metavariables); never
  put binders whose types use local scheme notation in `variable` commands (declarations
  silently vanish — verify keystones per-constant).
- Size discipline: the affine-opens poset of `T.left` is Type-u-small — this is the
  point of the vehicle; do NOT introduce Type (u+1) indexings.
- Files ≤ 500 lines (suggested: `Picard/PicEt.lean` the object/limit,
  `Picard/PicEtMap.lean` the glue functoriality, `Picard/PicEtAffineIso.lean` the
  comparison — split as content dictates); mathlib naming + complete docstrings;
  `set_option autoImplicit false`; wire the aggregator (a blueprint agent edits only
  `blueprint/**` concurrently); never touch `Challenge.lean`; no new axioms.
- Search before proving (`lean_local_search`, `lean_loogle`, `lean_leansearch`) —
  especially mathlib's opens-poset/limit and `IsBasis.isBasis_affineOpens` machinery.

## Verification (FOREGROUND, non-negotiable)

Iterate with the lean-lsp MCP; never two lake builds concurrently. When done: root
`lake build` blocked to completion (paste tail), `lean_verify` per keystone (axioms
exactly `[propext, Classical.choice, Quot.sound]`), `grep -n -w sorry` on touched files
(exits 1 on zero matches). Do NOT run git; do NOT commit.

## Report format

Files (line counts) · keystones with one-liners · vehicle decisions taken vs. I-0140's
sketch (and why, if any deviation) · build tail verbatim · lean_verify outputs verbatim ·
frontier if staged · what the (C2) and degree/Pic⁰ spec-writers must know.
