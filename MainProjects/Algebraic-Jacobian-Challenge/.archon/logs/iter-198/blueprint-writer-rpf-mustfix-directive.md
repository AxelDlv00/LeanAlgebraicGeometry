# Directive — blueprint-writer, `Picard_RelPicFunctor.tex` must-fix (iter-198)

## Mode
Update one chapter (`blueprint/src/chapters/Picard_RelPicFunctor.tex`) to clear the iter-198 blueprint-reviewer HARD GATE DEFER on `Picard_RelPicFunctor.tex`.

## Strategy context (the slice that matters)

A.1.c — relative Picard functor + étale sheafification. Iter-197 progress-critic discovered that the file's gate annotation citing `LineBundle.OnProduct` as a typed sorry has been stale for 10 iters (LineBundlePullback.lean closed iter-188); the real residual gate on L235 is the tensor-product `AddCommGroup` structure on `LineBundle.OnProduct` (Mathlib b80f227 monoidal-structure gap).

The blueprint-reviewer's HARD GATE DEFER says:
- **`thm:rel_pic_etale_sheaf_group_structure`** has no `\lean{...}` pin and does NOT appear in the chapter's "Lean encoding" section. This is the 6th of 6 prover-gate sorries; it lacks both a declaration name and a `\leanok` proof block. Without this pin, the prover cannot close the corresponding sorry.
- The "Verification flag" on `etSheaf` notes that the étale-Grothendieck-topology Mathlib API name is not confirmed.

## Required content

Make these specific edits to `Picard_RelPicFunctor.tex`:

1. **Add the missing `\lean{...}` pin block for `thm:rel_pic_etale_sheaf_group_structure`** — name the Lean declaration, write a proof sketch (the plus-construction sheafification preserves the abelian-group target via `CategoryTheory.Sheafification`), and place it in the "Lean encoding" section alongside the other declarations.

2. **Confirm the étale-Grothendieck-topology API name** — use `lean_leansearch` / `lean_loogle` to identify the Mathlib API that gives the étale topology on `Over (Spec k)`. Candidates to check (verify via leansearch):
   - `CategoryTheory.GrothendieckTopology.etale` (if exists)
   - `AlgebraicGeometry.Site.etaleTopology` (if exists)
   - The actual sheafification entry point (`GrothendieckTopology.Sheafify`,
     `Sheafification.functor`).
   Update the chapter's "Verification flag" to either confirm the API
   name or document the gap (then the chapter declares the API as a
   Mathlib gap to fill project-side under `mathlib-build` mode).

3. **Update the gate annotation prose** — the chapter must reflect that
   the actual residual gate on the `representable` body (Lean L235) is
   the tensor-product `AddCommGroup` structure on `LineBundle.OnProduct`,
   NOT the now-closed `LineBundle.OnProduct` typed sorry. Cite
   `LineBundlePullback.lean` L344-346 explicitly noting the
   `Scheme.Modules` monoidal-structure gap.

4. **Note L287-L482 closeability via sorry `addCommGroup` scaffold** —
   add prose that these 5 sorries can be filled axiom-cleanly modulo
   the file-local sorry `addCommGroup` instance at L205-235, collapsing
   the file from 6 sorries to 1 once the prover lands those (L235 remains
   gated on the Mathlib tensor-product gap).

## Citation discipline (mandatory)

For every external citation, include:
1. `% SOURCE: <pointer> (read from references/<file>)`.
2. `% SOURCE QUOTE:` — verbatim text.
3. `\textit{Source: …}` as the first visible prose line.

Key references:
- **Kleiman, "The Picard scheme"** §2 (relative Picard functor)
  + §3 (étale sheafification): `references/kleiman-picard-src/kleiman-picard.tex`.
- **Nitsure**, FGA Explained Ch. 5 §5.x (Quot context):
  `references/nitsure-hilbert-quot.pdf` / `references/fga-explained.pdf`.
- For the sheafification API: cite Mathlib's
  `CategoryTheory/Sites/Sheafification.lean` directly in `% Lean:`
  prose comments.

## Out-of-scope

- Do NOT add `\leanok` or `\mathlibok` markers (deterministic phases
  handle those).
- Do NOT touch any other chapter.
- Do NOT modify Lean files.
- Do NOT propose a re-architecture of the carrier abstraction.

## --write-domain (passed by dispatcher)

- `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- `references/**`
