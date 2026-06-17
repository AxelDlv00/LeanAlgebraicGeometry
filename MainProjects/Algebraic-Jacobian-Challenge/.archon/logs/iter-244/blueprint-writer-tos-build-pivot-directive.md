# Blueprint Writer Directive

## Slug
tos-build-pivot

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Strategy context
The section `\label{sec:tensorobj_pullback_monoidality}` (currently L2564–~3250) builds the
A.1.c critical-path substrate `IsInvertible.pullback` (pullback preserves ⊗-invertibility).
A Mathlib-idiom analysis (this iter, recorded in `analogies/presheaf-pullback-strong.md`, and
the prior `analogies/pullback-tensor.md`) has settled the route: the substrate is Mathlib-scale
via EVERY route, and the project now **commits to building the concrete strong-monoidal
inverse-image pullback** rather than the iter-243 local-trivialisation detour. The section must
be rewritten to reflect this committed route. The general comparison `\cref{lem:pullback_tensor_iso}`
is **no longer descoped** — it is the committed build target, and `\cref{lem:isinvertible_pullback}`
becomes a short corollary of it (the 3-line Stacks proof). The local-trivialisation lemma
`\cref{lem:isinvertible_implies_locallytrivial}` is **demoted off-path** (no longer the route).

## Required content

### 1. Rewrite the section preamble (the `\paragraph`s before the lemmas)
Replace the "The general comparison is descoped" + "The route: local trivialisation" +
"Two negative results" + "Guardrail" paragraphs with a preamble reflecting the committed build:
- **State the reduction.** `IsInvertible.pullback` (Stacks `lemma-pullback-invertible`) is a
  3-line consequence of two facts: (a) pullback commutes with `\otimes` for all modules
  (`\cref{lem:pullback_tensor_iso}`, the general strong-monoidality of pullback), and (b)
  `f^*\mathcal{O}_X \cong \mathcal{O}_Y` (`\cref{lem:pullback_unit_iso}`, DONE). Given the inverse
  `N` with `M\otimes N\cong\mathcal{O}_X`, pull back: `f^*M \otimes f^*N \cong f^*(M\otimes N)
  \cong f^*\mathcal{O}_X \cong \mathcal{O}_Y`.
- **State why the general iso is genuine content (not free).** Keep ONE negative-result
  paragraph: a mere oplax comparison map does NOT make pullback strong — global sections
  `\Gamma` is lax monoidal yet `\Gamma(\mathbb{P}^1,\mathcal{O}(1))=0` is not invertible, so one
  must genuinely prove the comparison `\delta` is an ISO. (This is why `lem:pullback_tensor_iso`
  is real work, not a corollary of the oplax `\cref{lem:presheaf_pullback_oplaxmonoidal}`.)
- **State the committed construction route** for `lem:pullback_tensor_iso` (decomposed; see item 2).
- **Remove** the "local trivialisation of the invertible pair", "cover route", and
  "guardrail: not stalkwise" framing — that route is abandoned. Remove the claim that
  `lem:pullback_tensor_iso` is descoped/off-path.

### 2. Rewrite `\cref{lem:pullback_tensor_iso}` as the COMMITTED build target (decomposed)
Keep its statement (the general iso `f^*(M\otimes_X N)\cong f^*M\otimes_Y f^*N`, natural, all
`M,N`, all `f`) and its `% SOURCE`/`% SOURCE QUOTE` (Stacks `lemma-tensor-product-pullback`,
`references/stacks-modules.tex:2393–2404`, proof "Omitted"). **Remove the "descoped / not
formalised / no Lean declaration" text.** Give it a `\lean{...}` pin (the planner will supply the
final name; use `AlgebraicGeometry.Scheme.Modules.pullbackTensorIso` as the intended name) and a
**full proof sketch decomposed into named atomic sub-lemmas** following the concrete-model route
from `analogies/presheaf-pullback-strong.md` (READ that file — it has the verified decomposition):
  - **(D1) Decomposition.** `\mathtt{pushforward}\,\varphi = \mathtt{pushforward_0}\,F\,R \circ
    \mathtt{restrictScalars}\,\varphi` (Mathlib `Presheaf/Pushforward.lean:86`), so taking left
    adjoints, `\mathtt{pullback}\,\varphi \cong \mathtt{extendScalars}\,\varphi \circ
    \mathtt{pullback_0}`, where `\mathtt{pullback_0} = (\mathtt{pushforward_0}).\mathtt{leftAdjoint}`.
  - **(D2) Scalar half is strong (free).** `\mathtt{extendScalars}\,\varphi` is strong monoidal
    via `TensorProduct.AlgebraTensorModule.distribBaseChange` (Mathlib
    `ModuleCat/Monoidal/Adjunction.lean`). So the comparison `\delta` for `pullback φ` is an iso
    **iff** the comparison `\delta_0` for `\mathtt{pullback_0}` is an iso.
  - **(D3) Topological half — the genuine build.** `\mathtt{pullback_0} = \mathrm{Lan}\,
    (\mathtt{Opens.map}\,f.\mathtt{base})^{\mathrm{op}}` (left Kan extension; `pushforward_0` is
    restriction along `F^{\mathrm{op}}`, Mathlib `Pushforward.lean:75`). Pointwise,
    `\mathtt{pullback_0}(M\otimes N)(V) = \mathrm{colim}_{(F\downarrow V)}(M(U)\otimes N(U))`
    while `(\mathtt{pullback_0}M\otimes\mathtt{pullback_0}N)(V) =
    (\mathrm{colim}\,M(U))\otimes(\mathrm{colim}\,N(U))`. The comparison is an iso because the
    comma category `(F\downarrow V) = \{U : f^{-1}V \subseteq U\}` is up-directed (`U_1\cup U_2`
    is an upper bound), and a filtered colimit commutes with the tensor product (the diagonal is
    final). State this as the named sub-lemma to build: a concrete pointwise-colimit model of
    `\mathtt{pullback_0}` + the filtered-colimit/tensor interchange making `\delta_0` an iso.
  - **(D4) Sheafify + transport.** Sheafify the presheaf iso (`\cref{lem:sheafify_tensor_unit_iso}`
    / the project's `sheafifyTensorUnitIso` brick), then transport the monoidal structure from
    the concrete model to the project's abstract `\mathtt{Scheme.Modules.pullback}` along
    `\mathtt{Adjunction.leftAdjointUniq}` (the iter-217 device used for
    `\cref{lem:tensorobj_restrict_iso}`), yielding `lem:pullback_tensor_iso` as a genuine iso.
  - Note explicitly (so the prover knows the cost honestly): the filtered-colimit/tensor
    interchange for `ModuleCat`-valued presheaves and the concrete `\mathrm{Lan}` pointwise model
    are **Mathlib-absent** and are the multi-hundred-LOC content; `distribBaseChange`,
    `leftAdjointUniq`, `sheafifyTensorUnitIso`, and the comparison MAP `\cref{lem:pullback_tensor_map}`
    are already in hand. This is a `mathlib-build` sub-lane; the prover builds bottom-up.

### 3. Rewrite the proof of `\cref{lem:isinvertible_pullback}`
Re-route its proof to the **3-line Stacks proof** (Stacks `lemma-pullback-invertible`):
add `% SOURCE: [Stacks], Modules, Lemma lemma-pullback-invertible (read from
references/stacks-modules.tex, L4142–4157)` with the verbatim `% SOURCE QUOTE:` of the lemma
statement and `% SOURCE QUOTE PROOF:` of its 3-line proof (copy verbatim from
`references/stacks-modules.tex:4142–4157`). The informal proof body: given `e : M\otimes N\cong
\mathcal{O}_X` (the `IsInvertible` witness), the witness for `f^*M` is `f^*N`, and the iso is
`f^*M\otimes f^*N \xrightarrow{(\text{lem:pullback\_tensor\_iso})^{-1}... }` — concretely
`(\mathtt{pullbackTensorIso})^{-1} \ggg (\mathtt{pullback}\,f).\mathtt{mapIso}\,e \ggg
\mathtt{pullbackUnitIso}`. Update its `\uses{...}` to depend on `lem:pullback_tensor_iso`,
`lem:pullback_unit_iso`, `def:scheme_modules_isinvertible` (DROP the dependency on
`lem:isinvertible_implies_locallytrivial`).

### 4. Demote `\cref{lem:isinvertible_implies_locallytrivial}` off-path
Keep the lemma block (the fact is true and may serve A.2.c's Quot-embedding later) but rewrite its
surrounding prose / `% NOTE:` to state it is **no longer on the `IsInvertible.pullback` path** —
the committed route is the strong-monoidal pullback build, which never needs local triviality.
Do not delete it; mark it as a future-A.2.c lemma, not an A.1.c dependency. Remove any text
claiming it is the route to `lem:isinvertible_pullback`.

## Out of scope
- Do NOT touch the group-law section (`sec:tensorobj_pic_carrier`), the deferred dual-bridge
  sorries (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`), or any other section.
- Do NOT add `\leanok` / `\mathlibok` markers (managed elsewhere).
- Do NOT write Lean tactic syntax in proof sketches — mathematical prose only.
- The general iso `lem:pullback_tensor_iso` is now IN scope (un-descoped); but do NOT attempt to
  write the filtered-colimit interchange proof in full rigour — give the decomposition (D1–D4)
  with enough detail for a prover to build bottom-up, flagging D3 as the genuine Mathlib-absent build.

## References
- `references/stacks-modules.tex`: L2393–2404 (`lemma-tensor-product-pullback`, statement for
  `lem:pullback_tensor_iso`, proof "Omitted"); L4142–4157 (`lemma-pullback-invertible`, the 3-line
  proof for `lem:isinvertible_pullback`); L4066–4140 (`lemma-invertible`, context for
  `lem:isinvertible_implies_locallytrivial`). Read and quote verbatim.
- `analogies/presheaf-pullback-strong.md` (this iter) — the verified concrete-model decomposition
  (D1–D4 above); read it for the precise Mathlib citations (`Presheaf/Pushforward.lean:86,75`,
  `distribBaseChange`, `leftAdjointUniq`, the `(F↓V)` up-directed argument).
- `analogies/pullback-tensor.md` (iter-242) — the same route (Analogue 2), prior rationale.
