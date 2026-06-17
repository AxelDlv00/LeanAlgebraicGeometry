# Blueprint Writer Report

## Slug
differentials-iter120

## Status
COMPLETE — `blueprint/src/chapters/Differentials.tex` rewritten to match
the Option (iii) algebra-Kähler refactor of `smooth_locally_free_omega`.
File is well-formed LaTeX (balanced `\begin`/`\end`, all labels resolve).

## Target chapter
`blueprint/src/chapters/Differentials.tex`

## Approximate lines added / removed
- Pre-edit: 177 lines.
- Post-edit: 197 lines.
- Net: ~+20 lines of prose; redistribution rather than a wholesale
  rewrite — Section 2 (theorem + proof) shrank by dropping Step 5;
  Section 3 (the new "Bridge ... out of autonomous-loop scope") added
  ~30 lines of prose. Sections 3 (converse) and 4 (out-of-scope
  catalog) are untouched.

## Changes Made

### 1. Chapter intro (L1–8 pre-edit, L1–7 post-edit) — REWRITTEN
- Restated the downstream-role paragraph to say "smoothness of $f$
  implies the appLE-algebra Kähler differential
  $\Omega_{\Gamma(X, V)/\Gamma(S, U)}$ is free of rank $n$ on every
  affine chart $V \to U$." The pre-edit phrasing was "pointwise local
  freeness of $\Omega_{X/S}$ on an affine basis of $X$" — algebra-Kähler
  is now the primary content; the presheaf connection is forwarded to
  the new bridge section.
- Replaced the bare "$f^{-1}\struct{S}$" reference in the first
  paragraph with "$f^{-1}_{\mathrm{psh}}\struct{S}$" (the
  presheaf-level inverse-image) to make the colimit-source nature
  visible from the chapter intro.

### 2. `lem:relative_kaehler_presheaf_obj` (L19–37) — REVISED
- The lemma statement now spells out
  `(f^{-1}_{\mathrm{psh}}\struct{S})(V) = colim_{f V ⊆ W ⊆ S}\struct{S}(W)`
  and explicitly says this is **not** $\struct{S}(U)$ for an arbitrary
  affine $U \supseteq f V$.
- Removed the false sentence "In particular, on an affine open
  $V = \Spec B$ whose image lies in $U = \Spec A$, the right-hand side
  coincides with the classical ring-theoretic $\Omega_{B/A}$." Replaced
  with: "The relationship between this colimit-source Kähler module
  and the classical $\Omega_{B/A}$ on an affine chart is the content
  of the bridge documented in Section~\ref{sec:bridge-out-of-scope}."
- Proof body lightly revised to mention `TopCat.Presheaf.pullback` as
  the left Kan extension definition. Still `\leanok` (body remains
  `rfl`).
- Updated `\rem{kahler_compatibility}` to say transfer is "for the
  colimit-source ring, not for $\struct{S}(U)$".

### 3. Section 2 / `thm:smooth_locally_free_omega` (L44–119 pre-edit) — REWRITTEN
- **Theorem statement**: now in algebra-Kähler form, exactly matching
  the new Lean signature in `AlgebraicJacobian/Differentials.lean:91-98`.
  Output: existence of affine `U ⊆ S` and affine `V ⊆ X` with $x \in V$
  and $V \subseteq f^{-1}U$, plus
  $\Omega_{\Gamma(X, V) / \Gamma(S, U)}$ free of rank $n$ over
  $\Gamma(X, V)$ under the appLE algebra structure.
- **`\uses{...}` on the theorem updated**: pre-edit used
  `\uses{def:relative_kaehler_presheaf, lem:relative_kaehler_presheaf_obj}`
  — the lemma is now removed from the proof obligations of the theorem.
  Post-edit: `\uses{def:relative_kaehler_presheaf}` only (kept for the
  chapter's existence — the theorem proof does NOT depend on the
  lemma in its current algebra-Kähler form, but the definition stays
  in the chapter's `\uses` chain).
- **Proof body**: Step 5 ("transfer back to $M_U$") DROPPED in full.
  Steps 1–4 are kept verbatim. Added a "Step 4.5: discharge the
  `Nontrivial B` side condition" paragraph that uses
  `AlgebraicGeometry.Scheme.component_nontrivial` (replaces the
  previous in-line "Side condition on `Nontrivial B`" mini-step).
- **`% NOTE:` block at L92–104 of pre-edit — DELETED.** Replaced by
  the new Section "Bridge to the relative cotangent presheaf — out of
  autonomous-loop scope" (label `sec:bridge-out-of-scope`).
- **Mathlib-name summary**: now lists **FIVE** verified names
  (the four ring-theoretic ones plus
  `AlgebraicGeometry.Scheme.component_nontrivial`), down from the
  pre-edit's six (which included `lem:relative_kaehler_presheaf_obj`).

### 4. NEW section between old §2 and old §3 — ADDED
- `\section{Bridge to the relative cotangent presheaf --- out of autonomous-loop scope}`
- `\label{sec:bridge-out-of-scope}` — referenced from chapter intro
  and from `lem:relative_kaehler_presheaf_obj` and
  `rem:kahler_compatibility`.
- A `\begin{remark}` block with `\label{rem:bridge_relative_kaehler_iso_appLE}`
  stating the $B$-linear iso
  $(\mathrm{relativeDifferentialsPresheaf}\,f).\mathrm{presheaf}(V)
   \cong_{B} \Omega_{B/A}$ under `IsAffineOpen U / IsAffineOpen V /
  V ≤ f⁻¹ U`. **No `\lean{...}` hint** (the iso is NOT implemented in
  Lean).
- A "Proof sketch" paragraph (outside any `\begin{proof}` block —
  intentional, so it carries no formalization obligation) walking
  through the cofinality + localization-of-rings argument:
  `A → A_colim = A_M` is a localization at
  `M := { g ∈ A : appLE(g) ∈ B^× }`; `Ω[A_M/A] = 0`; second exact
  sequence; `KaehlerDifferential.isLocalizedModule_map` packages the
  result.
- A "Why this iso is out of autonomous-loop scope" paragraph listing
  the three missing Mathlib pieces (cofinality, colim-as-localization
  identification, algebra-structure compatibility) with the 200–400
  LOC estimate.

### 5. Section 3 (Converse direction, L121–154 pre-edit) — UNCHANGED
Content and labels preserved verbatim. Now sits at L142–174 due to
the inserted bridge section.

### 6. Section 4 (Out-of-scope catalog, L156–177 pre-edit) — UNCHANGED
Four trimmed-content items preserved verbatim. Now at L176–197.

## Cross-references introduced
- `\ref{sec:bridge-out-of-scope}` added in chapter intro and in two
  Section-1 blocks (`lem:relative_kaehler_presheaf_obj` and
  `rem:kahler_compatibility`). Target `sec:bridge-out-of-scope` is
  defined in this same chapter (new Section 3). VERIFIED.
- `\ref{thm:smooth_locally_free_omega}` added inside
  `rem:bridge_relative_kaehler_iso_appLE`. Target defined in this same
  chapter. VERIFIED.
- `\ref{lem:relative_kaehler_presheaf_obj}` added in bridge proof
  sketch. Target defined in this same chapter. VERIFIED.

No cross-chapter `\ref` additions; all targets are local to
`Differentials.tex`.

## Verification checklist (matching directive's "Output" requirements)

| Item | Status |
| --- | --- |
| Lines of prose added / removed | ~+20 net (177 → 197); see breakdown above |
| L92–104 `% NOTE:` block gone | YES — `grep -n "% NOTE"` returns no matches |
| New `sec:bridge-out-of-scope` exists | YES — `\section` + `\label` at L108–109 |
| Bridge `\begin{remark}` with label `rem:bridge_relative_kaehler_iso_appLE` | YES — L113–122 |
| Bridge remark has NO `\lean{...}` hint | YES — verified by grep: the only `\lean{...}` hints in the file are at L15, L24, L51 (the three pre-existing leaf objects) |
| `thm:smooth_locally_free_omega` matches Lean signature | YES — algebra-Kähler form, existential carries `IsAffineOpen U / IsAffineOpen V / V ≤ f⁻¹ U`, conclusion is `Module.Free Γ(X, V) Ω[Γ(X, V) ⁄ Γ(S, U)] ∧ Module.rank ... = n` (matches `AlgebraicJacobian/Differentials.lean:91-98`) |
| `\uses{...}` updates on theorem | YES — dropped `lem:relative_kaehler_presheaf_obj` (the algebra-Kähler theorem does not depend on the colimit-source lemma); kept `def:relative_kaehler_presheaf` for the chapter's `\uses` graph integrity |

## Macros needed (if any)
None. All commands used (`\struct{}`, `\Spec`, `\Jac`, `\Hom`, `\rank`)
were already in the pre-edit chapter; no new macros introduced.

## Reference-retriever dispatches (if any)
None. The directive cited
`task_results/strategy-critic-iter120.md`,
`task_results/mathlib-analogist-cotangent-presheaf.md`,
`task_results/blueprint-reviewer-iter120.md`, and
`analogies/cotangent-presheaf-design.md` — all of which exist in the
project and were read for context. No external sources needed.

## Notes for Plan Agent

- **Blueprint-reviewer's "Jacobian.tex:6 broken `\ref{chap:Picard_Functor}`"
  finding** (must-fix-this-iter per the reviewer report, but outside
  this directive's scope): the directive explicitly limits write-domain
  to `Differentials.tex`, so I did NOT fix `Jacobian.tex:6`. If you
  want it folded in, dispatch a separate blueprint-writer on
  `Jacobian.tex` with that single edit, OR widen this writer's
  directive next iter.
- **The bridge remark `rem:bridge_relative_kaehler_iso_appLE` is
  intentionally NOT a `\begin{lemma}` block.** Per the directive, the
  bridge is a `\begin{remark}` documenting a Mathlib gap, NOT a
  formalization obligation. If a future iter decides to take Option
  (i) (close the bridge as a real Lean lemma), promote the remark to
  a lemma with a `\lean{...}` hint at that time.
- **`lem:relative_kaehler_presheaf_obj` retained its `\leanok` markers.**
  The Lean side
  (`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`)
  is unchanged by the iter-120 refactor (body still `rfl`), so the
  `\leanok` on statement + proof remains correct. (Per project rules,
  the `sync_leanok` phase will re-confirm this automatically.)
- **`thm:smooth_locally_free_omega` retained its `\leanok` on the
  statement block.** The Lean side has a `sorry` body for the
  algebra-Kähler form, so the statement is `\leanok` (declaration
  exists with at least a sorry) but the proof is NOT yet `\leanok`.
  The blueprint pre-edit had `\leanok` on both — the post-edit keeps
  `\leanok` on the statement and on the proof block. The
  `sync_leanok` phase will remove the proof-block `\leanok` based on
  the residual sorry; I did not touch markers per project rules
  (markers are managed by `sync_leanok` + review-agent, never by
  blueprint-writer).

## Strategy-modifying findings

None. The strategy was already updated by the iter-120 plan agent to
adopt Option (iii); this chapter rewrite is simply prose-side
realignment with the refactored Lean signature. The math is unchanged,
the scope of the autonomous loop is unchanged, and the catalog of
out-of-scope content (converse direction + four catalog items) is
unchanged.
