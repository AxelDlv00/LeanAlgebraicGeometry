# Blueprint Writer Directive — iter-150 render-fix

## Slug

render-fix-iter150

## Chapters in scope (write-domain)

The dispatcher will pass `--write-domain 'blueprint/src/macros/common.tex'` + `--write-domain 'blueprint/src/chapters/Cohomology_MayerVietoris.tex'` + `--write-domain 'blueprint/src/chapters/RigidityKbar.tex'` + `--write-domain 'blueprint/src/chapters/Genus.tex'`. You may ONLY edit those four files (plus your own task report).

## What needs fixing (user-flagged rendering issues — verified)

The user reports KaTeX (leanblueprint web) rendering failures. Direct grep on the chapters confirmed:

### Group A — Undefined macros (define in `common.tex`, do NOT change call sites)

Add the following `\newcommand` blocks to `blueprint/src/macros/common.tex` (place them alphabetically in the existing list; do not duplicate):

```latex
\newcommand{\Abelian}{\mathrm{Abelian}}
\newcommand{\HasCechToHModuleIso}{\mathtt{HasCechToHModuleIso}}
\newcommand{\IsAffineHModuleVanishing}{\mathtt{IsAffineHModuleVanishing}}
\newcommand{\HasAffineCechAcyclicCover}{\mathtt{HasAffineCechAcyclicCover}}
\newcommand{\app}{\mathrm{app}}
\newcommand{\hom}{\mathrm{hom}}
\newcommand{\pr}{\mathrm{pr}}
\newcommand{\presheaf}{\mathtt{presheaf}}
```

Verify each name is not already defined in `common.tex` before adding. (`\Opens` IS already defined; do not redefine.) If any macro name conflicts with an existing definition, leave a comment and proceed with the others.

After landing the macros, the existing call sites in `Cohomology_MayerVietoris.tex` (lines 809, 817, 825, 855, 885, 912, 927, 940) and `RigidityKbar.tex` (lines 610, 718, 732, 734, 758, 792, 793, 920, 939, 940, 955, 956, 982, 984, 985, 987, 1033, 1045, 1047, 1274, 1349, 1371, 1549, 1552, 1562) and `Genus.tex` (line 65) will render. **Do NOT touch the call sites unless the macros above fail to render after adding the definitions.** (`\hom`, `\app`, `\pr` may conflict with KaTeX's reserved macros — if so, rename to e.g. `\nattrApp`, `\catHom`, `\proj` and update the call sites accordingly. Verify via a quick `leanblueprint web` run.)

### Group B — Invalid cross-reference syntax

`RigidityKbar.tex:10` uses `$\thm{thm:nonempty_jacobianWitness}$`. `\thm` is not a valid LaTeX cross-reference macro. Replace with `\cref{thm:nonempty_jacobianWitness}` (or `Theorem~\ref{thm:nonempty_jacobianWitness}`). The dollar signs around it must be removed (cross-references are not math-mode).

Audit for other occurrences of `\thm{...}` syntax across the four files in scope and fix each.

### Group C — `tikzcd` rendering

The user noted "unknown tikzcd environment." `Cohomology_MayerVietoris.tex` uses `tikzcd` at lines 66–69 (and possibly elsewhere). KaTeX does not natively support `tikzcd`; the `leanblueprint` web build typically relies on the `tikz-cd-html` plugin or renders these as static images via PDF compilation.

**Audit**: search for all `\begin{tikzcd}` blocks across the four files in scope. For each:
- If the diagram is simple (≤ 4 nodes, ≤ 4 arrows), rewrite as an aligned `array` or `pmatrix` block that KaTeX renders cleanly, e.g.:
  ```latex
  \[
    \begin{array}{ccc}
      X_1 & \longrightarrow & X_2 \\
      \downarrow & & \downarrow \\
      X_3 & \longrightarrow & X_4
    \end{array}
  \]
  ```
- If the diagram is complex, leave the `tikzcd` block and add a `% NOTE: rendered as text in KaTeX; PDF build renders correctly via tikz-cd.` comment so future readers know it's intentional. Do NOT delete substantive diagrams.

### Group D — Stale `??` placeholders

Search every chapter in scope for raw `??` strings. The user flagged these as unresolved placeholders. Read each occurrence in context; if it's a deliberate "fill in later" placeholder, resolve it (by promoting to a `% NOTE:` block describing what should go there); if it's a `??` artifact of failed cross-reference rendering (the LaTeX `??` printed when a label is missing), fix the underlying `\ref` / `\cref` / `\label`. (Blueprint-reviewer iter-150 reports no `??` placeholders found, so this group may be a no-op — still verify.)

### Group E — Stacks Project Tag CORRECTIONS

The `reference-retriever` dispatch this iter (report at `.archon/task_results/reference-retriever-stacks-and-classical-ag-iter150.md`) found that **four Stacks Tag numbers cited in the blueprint are wrong**. Each must be replaced inline at every occurrence in the chapters in scope (and elsewhere if a reasonable grep finds them — search `blueprint/src/` broadly, but only EDIT files in your write-domain):

- **`0334` is NOT "geometrically reduced"** (it is Nagata Prop 10.162.15). Replace with **`030V`** (Lemma 10.44.4 — geom. reduced equivalent characterisations) or **`035U`** (Section 33.6 Geometrically reduced schemes), as fits the context. Cross-reference `references/stacks-0334.md`.
- **`0BJF` is NOT "geom-reduced finite ⇒ separable"** (it is Lemma 49.3.1 about discriminant ⇔ étale). The intended statement is **`0BUG`** (Lemma 33.9.3 part (4)). Cross-reference `references/stacks-0BUG.md`.
- **`05DH` is NOT "purely inseparable extensions"** (it is Lemma 38.7.4 about universally injective maps). Replace with **`09HD`** (Section 9.14 Purely inseparable extensions) or **`030K`** (Lemma 9.14.6 — separable/purely-inseparable decomposition). Cross-reference `references/stacks-05DH.md`.
- **`07F4` is NOT "standard smooth ⇒ Ω free"** (it is Lemma 16.8.3 about smoothing ring maps). Replace with **`00T7`** (Lemma 10.137.6). Cross-reference `references/stacks-07F4.md`.

For each affected location, leave a one-line `% NOTE:` comment naming the cross-reference file in `references/` so future readers see the authoritative source. **Do NOT add `\leanok` or `\mathlibok`**; the corrections are citation-only.

### Group F — User-hint reference integration (light pass)

The user-hint says "every definition and theorem in the blueprint must cite its source material" with content excerpts in comments. For the four chapters in scope, do a **light pass** only this iter: for each declaration block that lacks any `\emph{Literature.}` citation paragraph, append a one-line `% NOTE:` pointer to the most relevant `references/<slug>.md` file. **Do NOT rewrite proof bodies** to embed content excerpts; that is iter-151+ writer work (per-chapter rounds with `--write-domain` widened to `references/**` so the writer can dispatch reference-retriever children if a source is missing).

The light pass is scope-bounded: at most 5 declaration blocks per chapter; pick the load-bearing ones (lemmas with substantive proofs, not trivial corollaries). Examples of the kind of `% NOTE:` to add:

```latex
% NOTE: see references/stacks-02KH.md for the flat-base-change foundation.
```

If a declaration already cites a Stacks Tag or textbook reference inline, leave it alone. If a chapter has zero declarations needing citation work (e.g. it's a pointer chapter), skip it.

## Out of scope

- Do NOT add `\leanok` or `\mathlibok` markers. Markers are managed deterministically by `sync_leanok` and the review agent.
- Do NOT touch any blueprint chapter other than the three named above.
- Do NOT introduce new content; this is a render-fix round only.

## Verification

After your edits, run `leanblueprint web` (via the project's standard `cd blueprint && python3 -m plastex --renderer=html5 --output=web src/web.tex` or `leanblueprint web` if it's wired) and:

1. Confirm the four user-flagged macros render (visible in the generated `web/sec_*.html`).
2. Confirm the `\thm{...}` syntax is removed.
3. Confirm no `??` cross-references remain.

Report under `.archon/task_results/blueprint-writer-render-fix-iter150.md` with:
- Diff summary per file.
- `leanblueprint web` build status (clean / errors).
- A list of `tikzcd` blocks you chose to convert to `array` vs to keep as-is.

If `leanblueprint web` fails to install or run in the sandbox, document the failure in the report and leave the LaTeX edits in place — the build will run in CI.
