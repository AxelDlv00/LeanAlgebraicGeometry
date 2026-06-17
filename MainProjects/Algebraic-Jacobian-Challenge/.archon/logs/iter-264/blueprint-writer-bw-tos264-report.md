# Blueprint Writer Report

## Slug
bw-tos264

## Status
COMPLETE — all five directive items applied to `Picard_TensorObjSubstrate.tex`; no other chapter touched, no markers added.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Revised** `lem:slice_dual_transport` (item #1, MUST-FIX) — corrected the WRONG naturality
  sketch in **both** the statement block and the proof's final paragraph. Previously the whole
  naturality square was claimed to hold by `Subsingleton.elim`. Now split into two parts:
  (a) base-morphism uniqueness in `(Over V.unop)ᵒᵖ` by `Subsingleton.elim` (thin poset, ≤ one
  inclusion), and (b) the equation of `𝒪_Y(V)`-module maps, which reduces to the
  ε-naturality square of `restrictScalars` along `β_W` post-composed with the
  `dualUnitRingSwap = inv ε(restrictScalars β_W)` definition — explicitly flagged as a genuine,
  separate obligation that the thin-poset argument does NOT discharge.

- **Revised** `lem:slice_dual_transport` proof, `invFun` paragraph (item #2, MAJOR) — expanded
  the one-paragraph "Inverse, linearity, and naturality" into two paragraphs:
  - the open-image down-set coverage fact (`fV ⊆ range f` ⇒ every `W'' ≤ fV` equals
    `f.opensFunctor(f⁻¹ W'')`), named as the `IsOpenImmersion` mechanism and cross-referenced
    to the helper `image_preimage_of_le` (down-set identity `ι_!(ι⁻¹V)=V`);
  - the inverse `PresheafOfModules.Hom` component formula: mirrors `toFun` but uses
    `(f.appIso W'').hom` (not its inverse) and the ε-codomain swap itself
    `ε(restrictScalars β_W'')` (not `inv ε`), reindexed by the inverse down-set bijection;
  - `left_inv`/`right_inv` close component-wise by `Iso.inv_hom_id`/`Iso.hom_inv_id` of
    `f.appIso` plus cancellation of the down-set bijection.

- **Revised** `lem:slice_dual_transport` proof, `map_smul'` enumerate (item #3, MAJOR) — inserted
  a new step (ii) (renumbering the old (ii)→(iii) and updating the lead-in "two"→"three steps"):
  the β-naturality RING identity `s = (β.app W').hom c` matching the X-side pushforward-restricted
  scalar `s` with the Y-side `𝒪_Y(V)`-scalar `c`, obtained from `InternalHom.termRingMap_naturality`
  + naturality of β on the thin poset `Opens Y`; and named `ModuleCat.restrictScalars.smul_def'`
  as the lemma that unfolds the `restrictScalars` smul so `map_smul` can fire.

- **Revised** `lem:scheme_modules_hom_local_section` proof (item #4, MINOR) — added inline
  `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` at the prose invocation of the
  open-set equality `ι_i(ι_i⁻¹(V)) = V`.

- **Revised** `lem:pullback_tensor_map_basechange` (D3′) Sq1 + Sq4 discussion (item #5, MAJOR):
  - **(a)** added "The reduced tail goal" paragraph stating the post-R0-peel composite-adjunction
    unit identity isolated as `sheafificationCompPullback_comp_tail`, with the two-layer composite
    adjunction `B_φ := (PrPbPushAdj φ').comp sheafAdj`, the full displayed equation
    (`B_{h∘f}.unit.app P = sheafAdj_X.unit P ; (forget∘restrictScalars).map(U ; pushforward(h∘f).map(R1 ; R5 ; δ_pre))`),
    the definitions of `U`, `R1`, `R5`, `δ_pre`, and the route (keep LHS concrete; recover the two
    `sheafCompPb f/h` factors as f/h sub-units via `homEquiv_leftAdjointUniq_hom_app`; reassemble
    by unit-naturality of `pushforwardComp`/`pullbackComp`; sheafification-laden analog of
    `unitToPushforwardObjUnit_comp`, NOT rfl sectionwise since `B_f`/`B_h` are composite
    adjunctions). Added a "Dead-end (do not pursue)" note: transposing the whole tail equation back
    through `homEquiv` is CIRCULAR (re-folds to the original statement).
  - **(b)** added a paragraph in the Sq4 block stating the `pullbackValIso` composition-coherence
    sub-lemma (the `.val`-vs-helper-`.obj` connecting-object naturality consumed inside
    `pullbackTensorMap_restrict`) as a STANDALONE named brick — a corollary of Sq1 with its own
    statement and connecting-object bookkeeping, NOT inlined into Sq1.

## Cross-references introduced
- No new `\uses{}` cross-references added. The `\lean{...}` hints introduced point to helper Lean
  names (`image_preimage_of_le` in two spots, `dualUnitRingSwap` already present); these are
  inline declaration hints, not blueprint-label `\uses` edges, so the dependency graph is
  unchanged.

## References consulted
None. All five items are project-bespoke constructions (DUAL route-2 and D3′ Sq1 have no external
textbook proof, per the directive). No `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` lines were
written or altered; the existing source block on `lem:dual_restrict_iso` was left intact. No
reference-retriever dispatched (directive marked retrieval optional and project-original prose
acceptable).

## Macros needed (if any)
None. All edits use existing macros / plain math.

## Notes for Plan Agent
- LaTeX balance: the chapter reports `\begin{lemma}` 83 vs `\end{lemma}` 82, but this is
  **pre-existing and benign** — it comes entirely from commented-out `% "\begin{lemma}` /
  `% \end{lemma}"` delimiters inside `% SOURCE QUOTE` verbatim blocks (lines 1633, 1870, 1882: two
  commented begins, one commented end). Real environments are balanced; `proof` 65/65,
  `enumerate` 14/14. None of my edits touched any environment delimiter. No action needed, just
  noting so a future doctor pass isn't alarmed.

## Strategy-modifying findings
None. The fixes sharpen proof-sketch adequacy (the ε-naturality obligation in
`slice_dual_transport` was understated, and the D3′ Sq1 tail goal / Sq4 brick were
under-specified) but do not change the project's strategy or the provability of any stated result.
