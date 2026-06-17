# Blueprint Writer Report

## Slug
ts-routec213

## Status
COMPLETE — `lem:tensorobj_assoc_iso` rewritten to route (c) (locally-trivial scope,
local-on-a-cover whiskered-unit injectivity); bridge lemma added; flat-whisker
block annotated off-critical-path; group-law carrier forward note added; all
stale flat-route prose in the chapter aligned for internal consistency.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### Required edit 1 — rewrite `lem:tensorobj_assoc_iso` to route (c)
- **Re-scoped statement** `\label{lem:tensorobj_assoc_iso}` from `\otimes`-invertible
  to **locally trivial** (`LineBundle.IsLocallyTrivial`) hypotheses on `M, N, P`.
  Retitled "...on locally trivial objects". Kept the objectwise existence-of-iso
  remark (no naturality/pentagon).
- **Updated `\uses{}`** (statement + proof): DROPPED `lem:flat_whisker_localizer`
  and `def:scheme_modules_isinvertible`; ADDED `def:IsLocallyTrivial` (the
  local-triviality definition, located in `Picard_LineBundlePullback.tex`) and
  `lem:isiso_sheafification_map_of_W`.
- **Deleted** the "Flatness is free" paragraph and the obsolete iter-212 `% NOTE:`
  block that followed it; deleted both `\cref{lem:flat_whisker_localizer}`
  invocations inside steps 1 and 3.
- **Rewrote steps 1 and 3** with the route-(c) argument: the whiskered
  sheafification unit (`η ▷ P♭` step 1; `M♭ ◁ η` step 3) lies in `J.W` — local
  surjectivity free (right-exactness, `isLocallySurjective_whiskerLeft`); local
  injectivity local-on-target, checked on a trivialising cover where the whiskering
  object is `𝒪` (via `restrictIsoUnitOfLE`), the sectionwise/definitional presheaf
  tensor carrying the whiskered unit through the right/left unitor onto the locally
  injective `toSheafify` (`isLocallyInjective_toSheafify`); glue. Stated the prover
  note that `isLocallyInjective_whiskerLeft_of_flat` is the sieve template with its
  `Module.Flat.lTensor_exact` step swapped for the trivialisation step. Inversion
  under `a = sheafification` via the closed bridge
  `lem:isiso_sheafification_map_of_W`. Step 2 (`a.mapIso α`) unchanged.
- **Rewrote the closing paragraph**: now says the proof works entirely at the
  presheaf/section level on a trivialising cover; KEPT the (true) claims of no
  `MonoidalClosed (PresheafOfModules R)` and no open-immersion
  restriction-compatibility iso (`lem:tensorobj_restrict_iso`).

### Required edit 2a — `\lean{}` pin + prose on `lem:flat_whisker_localizer`
- Added `PresheafOfModules.W_whiskerRight_of_flat` to the block's `\lean{}` list.
- Added a prose paragraph: both halves proven, valid standalone, but OFF the
  associator critical path (associator uses route (c), not sectionwise flatness,
  which is false over non-affine opens).

### Required edit 2b — new bridge lemma `lem:isiso_sheafification_map_of_W`
- Added a new `\lemma` block (statement + proof) BEFORE `lem:tensorobj_assoc_iso`,
  `\lean{PresheafOfModules.isIso_sheafification_map_of_W}`. Statement: for a locally
  bijective `α : R₀ ⟶ Rsh.obj` and a module morphism `f` with
  `J.W ((toPresheaf R₀).map f)`, `sheafification α` sends `f` to an iso. Proof is a
  one-morphism reading of Mathlib's
  `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` (cited in prose; project-
  bespoke wrapping, NO external `% SOURCE QUOTE:`). `\uses{}` omitted (empty) per
  directive.

### Required edit 3 — forward note on the iso-class group carrier
- Added ONE short prose remark at the end of `lem:tensorobj_isoclass_commgroup`'s
  statement: the group law consumes the locally-trivial-scoped associator; if the
  `IsInvertible` carrier is retained, `IsInvertible ⇒ IsLocallyTrivial` (invertible
  sheaf is locally free of rank one) is the only added obligation and is off the
  associator critical path. Body otherwise untouched.

### Consistency edits (same chapter; needed so prose matches the new `\uses{}`/route)
- **Motivation §** — replaced the "invertible — hence flat — ... whiskered by a flat
  object" associator description with the locally-trivial / localizer-on-a-cover one.
- **Mathlib API survey §** — replaced the "flat-whiskering bridge" associator
  description with the route-(c) localizer-membership description; "no flatness".
- **`rem:scheme_modules_monoidal_off_path`** — rewrote the "flat whiskering objects"
  paragraph to "locally trivial whiskering objects" + local-on-a-cover, removed the
  stale iter-212 `% NOTE:` block, and changed "flat-whiskering three-step composite"
  to "locally-trivial-scoped three-step composite".
- **Internal-consistency check §** — updated the associator `\uses` description to
  the new labels/route, re-described `lem:flat_whisker_localizer` as off-critical-
  path, and added a chain item for the new `lem:isiso_sheafification_map_of_W`.

## Cross-references introduced
- `def:IsLocallyTrivial` — defined in `Picard_LineBundlePullback.tex:142`
  (`\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial}`). Verified present.
- `lem:isiso_sheafification_map_of_W` — newly defined in this chapter; referenced by
  `lem:tensorobj_assoc_iso` and the internal-consistency check.
- `lem:tensorobj_assoc_iso` continues to be consumed by
  `lem:tensorobj_isoclass_commgroup` (unchanged) — now satisfied on locally-trivial
  objects.

## References consulted
None for citation blocks — route (c) is project-bespoke (no new external
`% SOURCE QUOTE:` required, per directive) and the edit-3 forward note cites the
standard invertible⇔locally-free-rank-1 fact only informally (no `% SOURCE` line).
Read for grounding (not citations): `analogies/ts-monoidal213.md` (authoritative
route-(c) sketch + Decision blocks).

## Macros needed (if any)
None. All commands used already appear in the chapter (`\Scheme`, `\otimes_X`,
`\flat`, `\mathtt`, `\cref`, `\triangleleft`, `\triangleright`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- LaTeX environments balanced (13/13 non-comment lemmas; the 16/15 raw `grep` count
  is a truncated `% \begin{lemma}` inside a SOURCE QUOTE comment — harmless).
- The associator now has hypotheses `IsLocallyTrivial M N P`, while the carrier
  predicate downstream (`lem:tensorobj_isoclass_commgroup`,
  `lem:tensorobj_lift_onproduct`) is `IsInvertible`. The forward note (edit 3) flags
  the single connecting obligation `IsInvertible ⇒ IsLocallyTrivial`. The analogy
  notes the OnProduct consumers (`tensorObjOnProduct`, `exists_tensorObj_inverse`,
  `tensorObj_isLocallyTrivial`) are ALREADY stated with `IsLocallyTrivial`, so a
  prover may be able to thread local-triviality straight through without the bridge;
  if the `IsInvertible` carrier is kept for `tensorObjIsoclassCommMonoid`, schedule
  the small `IsInvertible ⇒ IsLocallyTrivial` lemma (off the associator critical
  path) as a separate prover target.
- Route (c)'s one unverified Mathlib sub-dependency (per the analogy): that
  `Presheaf.IsLocallyInjective` / the locally-bijective `J.W` is local-on-a-cover.
  The prover should confirm this lemma exists (or prove it by sieve bookkeeping
  mirroring `isLocallyInjective_whiskerLeft_of_flat`) before relying on step-1/3
  injectivity.

## Strategy-modifying findings
None. Route (c) was vetted this iter and is consistent with STRATEGY; this writer
only realigned the chapter prose to it.
