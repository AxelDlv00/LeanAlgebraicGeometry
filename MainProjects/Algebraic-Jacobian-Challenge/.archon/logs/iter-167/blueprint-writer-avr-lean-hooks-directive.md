# Directive: blueprint-writer — slug `avr-lean-hooks` (chapter `AbelianVarietyRigidity.tex`)

## Mission

Add the per-decl `\lean{...}` hooks for the genus-0 base objects and their companion lemma
that landed in `AlgebraicJacobian/Genus0BaseObjects.lean` (iter-165 / iter-166). The
lean-vs-blueprint-checker `g0bo-iter166` report flagged 6 MAJOR coverage gaps — the
substantively-claimed declarations exist in Lean and are referenced in chapter prose, but
lack their own per-decl `\lean{...}` blocks so the blueprint-doctor cannot statically link
them.

## Strategy context (one slice)

The chapter `AbelianVarietyRigidity.tex` already pins:
- `\lean{AlgebraicGeometry.ProjectiveLineBar}` inside `def:genus0_base_objects`
- `\lean{AlgebraicGeometry.gmScalingP1}` inside `def:gaTranslationP1`

But the bundle `def:genus0_base_objects` describes THREE objects (`ProjectiveLineBar`, `Ga`,
`Gm`) under a single `\lean{...}` block, and the distinguished `k̄`-points and group-object
structures aren't pinned at all. The `def:gaTranslationP1` block describes the σ_× action's
fixed-point property in prose but doesn't pin the corresponding companion lemma
`gmScalingP1_collapse_at_zero`.

## Required edits

### Edit 1 — Split the `def:genus0_base_objects` block into per-decl pins

In the bundled `def:genus0_base_objects` block (currently at chapter L908-939), keep the
overall framing prose, but EITHER:
- (option A — recommended) Add three sibling `\lean{...}` blocks below the main bundle, OR
- (option B) Split the bundle into three separate `\begin{definition}...\end{definition}`
  blocks.

The Lean declarations that must end up pinned:
- `AlgebraicGeometry.ProjectiveLineBar` — the projective line (already pinned).
- `AlgebraicGeometry.Ga` — the additive group `𝔾_a` over `Spec k̄`. Add a per-decl pin.
- `AlgebraicGeometry.Gm` — the multiplicative group `𝔾_m` over `Spec k̄`. Add a per-decl pin.
- `AlgebraicGeometry.ProjectiveLineBar.zeroPt` — the `[0:1]` point. Add a per-decl pin.
- `AlgebraicGeometry.ProjectiveLineBar.onePt` — the `[1:1]` point. Add a per-decl pin.
- `AlgebraicGeometry.ProjectiveLineBar.inftyPt` — the `[1:0]` point. Add a per-decl pin.
- `AlgebraicGeometry.Gm.onePt` — the multiplicative identity `1 ∈ 𝔾_m` (defined as `η[Gm]`).
  Add a per-decl pin.
- `AlgebraicGeometry.ga_grpObj` — the additive `GrpObj` structure on `Ga`. Add a per-decl pin
  (the body is `sorry` off-path; the pin still tracks the declaration's existence).
- `AlgebraicGeometry.gm_grpObj` — the multiplicative `GrpObj` structure on `Gm`. Add a
  per-decl pin (currently `sorry`; iter-167 closes it).

For each of these, the pin's prose should be the corresponding sub-bullet from the current
bundle (or a one-sentence cross-reference if the bundle already says enough). The chapter's
current "[expected]" annotations for `Ga`, `Gm`, `gaTranslationP1` (chapter L923, L929, L934,
L951-953) should be promoted to real `\lean{...}` hooks now that the Lean names are landed.

### Edit 2 — Add the σ_× fixed-point companion lemma block

Below the `def:gaTranslationP1` block (chapter L941-989), add a new lemma block:

```latex
\begin{lemma}
[The $\mathbb G_m$-scaling action fixes the origin $0 \in \mathbb P^1$]
  \label{lem:gmScaling_fixes_zero}
  \lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}
  \uses{def:genus0_base_objects, def:gaTranslationP1}
  % Archon-original; the fact is elementary (σ_×(0, λ) = λ · 0 = 0).
  Let $\sigma_\times \colon \mathbb P^1 \times \mathbb G_m \to \mathbb P^1$ be the scaling action.
  Then the composite
  \[ \mathbb G_m \xrightarrow{\;(\mathrm{toUnit}_{\mathbb G_m} \fatsemi 0_{\mathbb P^1}, \mathbf 1_{\mathbb G_m})\;}
     \mathbb P^1 \times \mathbb G_m \xrightarrow{\;\sigma_\times\;} \mathbb P^1 \]
  equals the constant morphism $\mathrm{toUnit}_{\mathbb G_m} \fatsemi 0_{\mathbb P^1}$. That is,
  $\sigma_\times(0, \lambda) = 0$ for every $\lambda \in \mathbb G_m$.
\end{lemma}
\begin{proof}
  \uses{def:gaTranslationP1}
  Chart-level. On the affine chart $\mathbb A^1 \times \mathbb G_m$ (coordinate $x$), the
  morphism $\sigma_\times$ is the polynomial map $(x, \lambda) \mapsto \lambda \cdot x$. Restricting
  to the $\mathbb G_m$-section $x = 0$ gives the constant ring map $k\bar[t, t^{-1}] \to k\bar$,
  $\lambda \mapsto 0$; equivalently the scheme morphism factors through the closed point
  $0 \in \mathbb P^1$. The agreement with the other chart $u = 1/x$ near $\infty$ is automatic
  (the section $x = 0$ does not meet that chart). The named equation is the Lean encoding
  of this fact, with $\mathrm{toUnit}_{\mathbb G_m}$ supplying the
  $\Spec \bar k$-factor and $\mathbf 1_{\mathbb G_m}$ the parameter $\lambda$.
\end{proof}
```

Place the new block immediately after the `def:gaTranslationP1` block, BEFORE the
`lem:hom_Ga_to_av_trivial` block.

### Edit 3 — Cross-reference from the consumer prop

In `prop:morphism_P1_to_AV_constant`'s proof block (chapter L1224-1278 or thereabouts), where
the `W`-axis collapse is described, add a `\cref{lem:gmScaling_fixes_zero}` citation so the
reader can locate the load-bearing fixed-point fact. ONE citation is sufficient.

## Constraints

- DO NOT add `\leanok` or `\mathlibok` markers anywhere. The sync phase / review agent owns
  those.
- DO NOT touch existing `\lean{...}` hooks that already resolve correctly.
- DO NOT renumber existing labels or change existing label names. New labels (the new lemma
  block) must use the convention `lem:gmScaling_fixes_zero`.
- Keep the chapter under the project's standard length / style. Long verbatim source quotes
  are fine where Archon-original prose is being added (the new lemma is Archon-original; no
  external `% SOURCE QUOTE` block is required).
- Do NOT need to retrieve new references for these edits — they are Lean-side coverage
  hooks, not new mathematics.

## Out of scope (do NOT do this iter)

- Discharging the actual `sorry` bodies — that's the prover agent's job.
- Splitting `def:gaTranslationP1` into separate `def:gmScalingP1` + `def:gaTranslationP1`
  blocks — leave the bundled definition shape as-is; only add the companion lemma block per
  Edit 2.
- Adding `\lean{...}` hooks for the OFF-PATH demoted declarations (`lem:rational_map_to_av_extends`,
  `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial`) — their off-path status is
  intentional and the lean-vs-blueprint-checker report flagged these as informational, not
  must-fix.
- Mathematical rewrites of the existing proof bodies — leave them as-is, only add the new
  blocks/hooks.

## Verification

After your edits:
- `def:genus0_base_objects` should be backed by per-decl `\lean{...}` hooks for all 9 Lean
  decls listed in Edit 1.
- New lemma block `lem:gmScaling_fixes_zero` with its `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}`
  hook should be present between `def:gaTranslationP1` and `lem:hom_Ga_to_av_trivial`.
- The `prop:morphism_P1_to_AV_constant` proof should cite `\cref{lem:gmScaling_fixes_zero}`
  at the W-axis-collapse step.
- All your edits should compile (the blueprint-doctor will flag broken refs in the next iter
  if something went wrong).
