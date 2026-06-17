# Blueprint-clean report — iter-019

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Changes made

### 1. `def:cohomology_sheaf_is_sheafify_homology` (new engine block)

**Lean typeclass leak — statement (`\mathrm{HasSheafify}`):**
- Replaced `"over a site equipped with sheafification (\(\mathrm{HasSheafify}\))"` with `"over a site admitting sheafification"`.

**Lean dot-notation in display formula:**
- Replaced `\bigl(\operatorname{sheafify} K\bigr).\mathrm{homology}\,i \cong \operatorname{sheafify}\bigl(K.\mathrm{homology}\,i\bigr)` with standard math `H^i(\operatorname{sheafify}(K)) \cong \operatorname{sheafify}(H^i(K))`.

**Lean typeclass leak — proof (`\mathrm{HasSheafify}`):**
- Replaced `"over a site with \(\mathrm{HasSheafify}\)"` with `"on a site admitting sheafification"`.

**Lean dot-notation in proof chain:**
- Replaced `K.\mathrm{homology}\,i \cong (\operatorname{sheafify} K).\mathrm{homology}\,i \cong \operatorname{sheafify}(K.\mathrm{homology}\,i)` with `H^i(K) \cong H^i(\operatorname{sheafify} K) \cong \operatorname{sheafify}(H^i(K))`.

**Missing citation anchor — Stacks 01XJ:**
- Added `% NOTE:` annotation after the `\lean{...}` list: the block mentions Stacks Tag~01XJ in the body as background motivation, but `lemma-describe-higher-direct-images` does not state sheafification commuting with homology of an arbitrary complex as a standalone lemma. This is a project-built generalization; no verbatim Stacks source quote is applicable. The NOTE records this explicitly.

### 2. `lem:higher_direct_image_presheaf` (re-signed to resolution form)

**Lean syntax in statement:**
- Removed `X.\mathrm{Modules}`, `[\,\mathrm{HasInjectiveResolutions}\;X.\mathrm{Modules}\,]`, and `(f_*).\mathrm{rightDerived}\,k` from the opening hypothesis sentence; replaced with `"the category of \(\mathcal{O}_X\)-modules has enough injective objects"` and `"the derived pushforward \(R^k f_*\) is defined"`.
- Removed `\(X.\mathrm{Modules}\)` as the ambient category for the resolution choice; replaced with `\(\mathcal{O}_X\)-modules`.
- Removed the Lean-style equality `R^k f_*\mathcal{G} = (f_*).\mathrm{rightDerived}\,k\,(\mathcal{G})` from the statement.

**Project-scope commentary in statement:**
- Replaced `"We record honestly the scope of the formalised content. ... is \emph{not} part of this lemma's Lean content; the lemma stops at the resolution-internal..."` with clean mathematical prose: `"The identification ... is supplied at point of use; this lemma records the resolution-internal sheafify-of-objectwise-homology form."`.

**Lean syntax in proof:**
- Removed `\(X.\mathrm{Modules}\)` from resolution setup; replaced with `\(\mathcal{O}_X\)-modules`.
- Removed the equality `R^k f_*\mathcal{G} = (f_*).\mathrm{rightDerived}\,k\,(\mathcal{G})`.
- Removed inline Lean declaration name `\(\mathrm{pushforwardResolutionPresheafComplex}\)` from the prose (the name remains legitimately in the `\lean{...}` coverage list).
- Replaced `"taking homology in \(S.\mathrm{Modules}\)"` with `"taking homology in \(\mathcal{O}_S\)-modules"`.

**Project commentary in proof:**
- Removed the final two paragraphs: `"No presheaf-level \(\delta\)-functor formalism is required: the route is entirely..."` (editorial) and `"The final identification ... lies outside the resolution-internal content recorded here."` (project-scope commentary duplicating the statement's remark). The proof now ends after the affine-local vanishing criterion sentence.

## What was NOT changed

- `\lean{...}` coverage lists (including `AlgebraicGeometry.pushforwardResolutionPresheafComplex`) — preserved as-is.
- All `\uses{}` edges, `% SOURCE` citation blocks, and `% SOURCE QUOTE` annotations — preserved.
- `\leanok` markers — not added or removed.
- Blocks outside the directive scope (`lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology`, `lem:mod_pmod_adjunction`) — not touched, even though they contain older `(f_*).\mathrm{rightDerived}` and `X.\mathrm{Modules}` occurrences predating this iteration.

## Citation status

- `def:cohomology_sheaf_is_sheafify_homology`: no verbatim Stacks source quote needed; `% NOTE:` marks it as project-built. ✓
- `lem:higher_direct_image_presheaf`: carries its `% SOURCE QUOTE` from Stacks 01XJ (`lemma-describe-higher-direct-images`, L591–603 of `references/stacks-cohomology.tex`). ✓
