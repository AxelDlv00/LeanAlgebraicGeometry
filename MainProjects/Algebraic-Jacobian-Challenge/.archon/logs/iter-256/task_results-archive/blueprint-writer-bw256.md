# Blueprint Writer Report

## Slug
bw256

## Status
COMPLETE — both directed proof-sketch refinements made; no other blocks, markers, or chapters touched.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### Fix 1 — `lem:sheafofmodules_hom_of_local_compat` proof, sub-step (c)
- **Revised** `lem:sheafofmodules_hom_of_local_compat` (proof). The trailing
  "The other three sub-steps are mechanical: (b) … (c) the sectionwise linearity check;
  and (d) …" sentence previously lumped (c) in with the mechanical steps. Split it:
  - The framing sentence now reads "Two of the remaining sub-steps are mechanical: (b) …
    and (d) …" — (c) removed from the mechanical list.
  - Added a dedicated paragraph + three-item `itemize` for sub-step (c), declaring it
    **not mechanical** and recording the real obstacle as mathematics (a localization /
    identity-ring-map identification of module actions):
    - **(c.i)** M-leg semilinearity via the native Γ-module-level functoriality identity
      `Scheme.Modules.map_smul M` (`M(i)(r·x) = X(i)(r)·M(i)(x)`, no restrictScalars
      artifact) — closes cleanly.
    - **(c.ii)** f-leg obstacle: `(f_i).app(P)` is linear over the `restrictScalars`
      action of `(M|_{ι_i})(P)`, vs. the goal's native `O_X(image)`-action — propositionally
      but not definitionally equal. Bridge: open-immersion structure-ring iso is the
      identity (`(U_i).ι.appIso = Iso.refl`), so the restrict ring map is `𝟙`, and
      restriction along the identity ring map returns the native action
      (`c ·_{restr 𝟙} x = 𝟙(c)·x = c·x`), identified via
      `ModuleCat.restrictScalars.smul_def` + `restrictScalarsId'App`. Named as the genuine
      content of (c).
    - **(c.iii)** N-leg via `Scheme.Modules.map_smul N` once the bridge is in place; the
      transported scalars reconcile because the two open-set `eqToHom` maps from
      `ι_i(ι_i⁻¹(W)) = W` compose to the identity on the overlap.
  - Mathlib lemmas named as tools (consistent with the chapter's existing style); no Lean
    tactic strings.

### Fix 2 — `lem:dual_restrict_iso` proof, Step 4
- **Revised** `lem:dual_restrict_iso` (proof). Recast Step 4 as two stages so a prover does
  not hit the omitted adjunction-uniqueness rewrite:
  - Reframed the "factors into two legs" intro sentence to announce a preliminary
    **stage H1** (adjunction-uniqueness rewrite) followed by the two legs resolving the
    **residual**.
  - Inserted a dedicated **Stage H1** paragraph before Leg (A): use uniqueness of left
    adjoints (`pushforwardPushforwardAdj` composed with `leftAdjointUniq`) to rewrite the
    `pullback φ`-form into a `pushforward β`-form; states the residual obligation
    explicitly as
    `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`
    ("pushforward β commutes with the dual"), and states that legs (A)/(B) resolve this
    residual — content remaining *after* H1, not a standalone two-leg split of the whole
    step.
  - Updated the composite sentence: the H1 residual is the sectionwise composite of
    leg (A) ∘ leg (B), and full Step 4 = H1 isomorphism ∘ that composite.
  - Updated the closing "Composing legs (A) and (B) …" sentence: the assembled/sheafified
    composite resolves the H1 residual, and precomposing with the H1 rewrite yields the
    stated `(dual M)|_f ≅ dual(M|_f)`.

### Formatting cleanup
- No `\leanok` introduced anywhere. All `\uses{...}` lines left untouched (still begin with
  label tokens). Replaced one raw unicode `Γ` I had typed with `\(\Gamma\)` to match the
  chapter's Greek-in-math convention and avoid a compile issue.

## Cross-references introduced
- None. No new `\uses{...}` labels added (the H1 rewrite and the (c) bridge are
  Archon-original sub-steps named only by Lean lemma, not by blueprint label). Existing
  `\uses` lists on both blocks are unchanged and still valid.

## References consulted
- None. Both edits are Archon-original sub-step refinements (no external claim added); the
  existing `% SOURCE:` / `% SOURCE QUOTE:` lines on both blocks were left intact and not
  re-derived. Per the directive, no source fetch was needed.

## Macros needed (if any)
- None. Only existing macros (`\mathtt`, `\mathcal`, `\cref`, `\emph`, `itemize`,
  `\Gamma`, `\Scheme`) are used.

## Notes for Plan Agent
- The proof's later "(ii) Promote to O_X-linear" paragraph (global linearity across the
  cover) is conceptually adjacent to the new sub-step (c) (sectionwise linearity within the
  gluing engine) but they are distinct steps; left (ii) untouched per scope.
- Both edited blocks are within the homOfLocalCompat / dual_restrict_iso proofs only;
  D1'/D2'/D3'/D4', `homLocalSection`, `dual_unit_iso`, `dual_isLocallyTrivial` untouched.

## Strategy-modifying findings
- None.
