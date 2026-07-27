Audit complete. Report below; nothing was edited.

## Blueprint `.tex` prose — offenders, worst first

1. **`blueprint/src/chapters/Picard_Pic0AbelianVariety.tex:29`** (also `:1553-1554`) — "the Lean target file `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` does not yet exist; this chapter is the authoritative informal specification, and the Lean skeleton is owed in a follow-up iteration."
   False: `/home/axel/.../AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` exists (907 lines) and contains all five pinned declarations; `tangentSpaceIso`, `geometricallyIrreducible`, `grpObj`, `isAbelianVariety` are assembled, only `smooth` (:806), `proper` (:826) and `finrank_cotangentSpaceDual_eq_finrank_h1Cok` (:672) are `sorry`.
   Fix: "The Lean target file … exists; `tangentSpaceIso`, `geometricallyIrreducible` and the `isAbelianVariety` assembly are proved, and the remaining `sorry` bodies are `smooth`, `proper` and the finrank sub-lemma."

2. **`Picard_IdentityComponent.tex:40`** and **`Picard_Pic0AbelianVariety.tex:756`, `:810`** — "the étale-sheafified relative Picard functor of \(C/k\) is represented by the \(k\)-group scheme \(\Pic_{C/k}\)" / "\(\Pic_{C/k}\) exists and represents the étale-sheafified relative Picard functor".
   Misleading twice over: the Lean object represents `picSharp C` (the *plain* relative functor, `FGAPicRepresentability.lean:576`), and the identification with the étale sheaf holds only under `[HasRationalPoint C]` — which is exactly the open human decision. Stating the étale sheaf as the represented object silently picks the branch that was not chosen.
   Fix: "…the plain relative Picard functor \(\Pic^\sharp_{C/k}\) is represented by \(\Pic_{C/k}\) (which, under the standing \(k\)-rational-point hypothesis, coincides with its étale sheafification; whether to keep that hypothesis or represent the sheafification instead is an open decision, \cref{sec:fga_pic_setup})."

3. **`Picard_IdentityComponent.tex:44-46`** — "The disjoint-union structure of \(\Pic_{C/k}\) stratifies its \(T\)-points by the Hilbert polynomial of the representing invertible sheaf relative to a fixed polarisation."
   This is the Quot/Kleiman §4 stratification, i.e. route (A) machinery, presented as the ambient structure of the current object. The route of record decomposes `picSharp` by *fibre degree* (campaign B4, `picSharpDeg`), not by Hilbert polynomial.
   Fix: "…decomposes into clopen pieces indexed by the fibre degree of the representing invertible sheaf (the degree decomposition of the Milne–Kollár route; along the quotient route the same pieces are indexed by Hilbert polynomial)."

4. **`Picard_IdentityComponent.tex:1165-1180`** and **`:1235-1240`** — degree characterised as "the leading coefficient of the Hilbert polynomial of a representing invertible sheaf", and "On the disjoint-union decomposition of \cref{thm:fga_pic_representability} the degree is the index of the component."
   Same route-(A) framing, and it pins the still-unbuilt `PicScheme.degree` (`IdentityComponent.lean:1432`, `sorry`) to Quot machinery. The campaign explicitly repins `degree` on the B4 degree definition.
   Fix: replace "Hilbert polynomial … leading coefficient" by "fibre degree of a representing invertible sheaf (equivalently, the leading coefficient of its Hilbert polynomial)", and "On the degree decomposition of \(\Pic^\sharp_{C/k}\) the degree is the index of the component."

5. **`Picard_FGAPicRepresentability.tex:31-32`** — "This is the route of \cref{thm:fga_pic_representability} and its proof below."
   True as bibliography, but read as project state it says the theorem of record is proved along route (A). Note `thm:fga_pic_representability` carries `\leanok` while the Lean `representable` (`:576`) is an extraction from the `sorry`-bodied `instHasPicScheme` (`:259-263`).
   Fix: "This is the route along which \cref{thm:fga_pic_representability} is *stated and proved informally* below; the Lean witness is obtained from \cref{def:inst_has_pic_scheme}, which is the project's single sorry-bodied instance and is being discharged along the Milne–Kollár route."

6. **`Picard_FGAPicRepresentability.tex:1072-1078`** — "The construction of \(\Pic_{C/k}\) separates into three mathematical inputs: the relative-divisor functor, its Abel map …, and the FGA existence theorem."
   That is the route-(A) decomposition presented as *the* decomposition, in a section titled "Dependencies of the representability theorem". The Milne–Kollár inputs (rigid pushforward, uniform \(H^1\), \(\Div^d\) representability, finite Galois quotient) are listed only later, at `:1088-1098`.
   Fix: open the section with "Along the route being formalised the inputs are those of \cref{subsec:sorry_has_pic_scheme}; the three inputs below are the quotient-route decomposition, retained because the divisor and Abel-map substrate is shared."

7. **`Picard_FGAPicRepresentability.tex:1156-1162`** ("Assembly of the inputs") — "The FGA construction consumes the relative-divisor functor and Abel map, then applies the regularity, base-change, and effective-quotient results of \cref{thm:fga_pic_representability}."
   "Effective-quotient results" is Altman–Kleiman descent, permanently off-path; this paragraph is the chapter's closing statement of how the scheme is built.
   Fix: state the Milne–Kollár assembly (glue \(J^\Sigma\) → finite Galois descent → coproduct over degrees) and add "The quotient-route assembly, retained above, consumes the same divisor and Abel-map substrate."

8. **`Picard_FGAPicRepresentability.tex:988-999`** (proof of `def:inst_has_pic_scheme`) — "Either route of \cref{sec:fga_pic_setup} then produces the representing scheme."
   The one thing this proof block must say is that it is *not* proved: `instHasPicScheme` is the single genuine sorry-bodied instance producing `HasPicScheme`, conditional on `[HasRationalPoint C]`, with ~41 downstream use sites that pick up `sorryAx` on synthesis.
   Fix: prepend "This is the project's single unproved instance (`⟨sorry⟩`), conditional on `[HasRationalPoint C]`. The route being formalised is the Milne–Kollár one: …".

9. **`Picard_FGAPicRepresentability.tex:259-262`** (proof of `thm:fga_pic_representability`) — "the underlying algebraic engine is the Quot scheme of \cref{chap:Picard_QuotScheme}".
   Fine as the quotient-route proof, but unlabelled; a reader takes it as the engine of record. Add one clause: "(this is the quotient-route proof; the route being formalised is \cref{sec:fga_pic_milne_kollar})". Note `thm:quot_representable` itself is `sorry` in Lean (`QuotRepresentability.lean:79`), so no mathematics is lost by relabelling rather than deleting.

10. **`RiemannRoch_Adelic.tex:2057`** — "This is the curve-level replacement for Castelnuovo–Mumford boundedness in the Quot endgame."
    "Quot endgame" names route (A) as the endgame. The vanishing corollary is what feeds uniform \(H^1\) vanishing (campaign P5) on the route of record.
    Fix: "…replacement for Castelnuovo–Mumford boundedness: on the quotient route it stands in for the Quot boundedness step, and on the route of record it feeds uniform \(H^1\) vanishing."

11. **`Picard_FlatteningStratification.tex:2739-2741`** — "Combining the resulting Quot spaces with the relative Picard functor is a separate representability argument."
    Not false, but it is the only forward-pointer in the chapter and it points at the off-path route, leaving the reader unaware that the stratification is reused by the committed route.
    Fix: add "…; that argument is the quotient route, which is not the one being formalised. The stratification itself is sorry-free substrate consumed by both routes."

12. **`Picard_IdentityComponent.tex:28-30`** — "Remaining sorries are confined to §3–§4 (`degree`, `finrank_eq_genus`, `kPoints_iff_kerDegree`), blocked on the FGA representability foundation (`AJC.picrep`)." Accurate on the sorry list (`IdentityComponent.lean:1432/1475/1504`), but `degree` is additionally blocked on the B4 degree decomposition, not only on `instHasPicScheme`. Optional one-clause fix.

## hgraph node prose (sync-generated mirrors — fix the source, the node regenerates)

- **`hgraph/nodes/0af72da2fa12.md:56-59`** — "(a disjoint union of open quasi-projective `k`-subschemes, indexed by Hilbert polynomial via `PicScheme.smoothProperQuotient`)". Flatly wrong: `smoothProperQuotient` is permanently off-path, has no global instance, and indexes nothing. Source: `AlgebraicJacobian/Picard/IdentityComponent.lean` §3 header. Fix: drop the `smoothProperQuotient` attribution; say "indexed by fibre degree".
- **`hgraph/nodes/c54a5ec4d0bb.md:13,21,41`** (`PicScheme.degree` docstring, `IdentityComponent.lean:~1405-1425`) — "because `PicScheme C` represents the étale-sheafified relative Picard functor" and "forming its Hilbert polynomial with the machinery of the sibling file `Picard/QuotScheme.lean`". The first picks the unresolved branch; the second plans the discharge through route-(A) machinery. Fix: "represents `picSharp C`" and "obtained from the degree decomposition of `picSharp` (campaign B4)".
- **`hgraph/nodes/3ca35b5f41a7.md:38`** (blueprint mirror of `def:divisor_degree_pic`) — same étale-sheafified claim as item 2; fixed by editing `Picard_IdentityComponent.tex`.
- **`hgraph/nodes/e07dfa671d41.md`** (docstring of `instHasPicScheme`, source `FGAPicRepresentability.lean:246-258`) — attributes the sorry's content solely to "Kleiman §4 Thm `th:main` + Cor `cor:algsch`", i.e. the quotient route. The `[HasRationalPoint C]` conditionality and the Zariski-sheaf justification are already correct; only the route attribution is stale. Fix: add "The discharge route of record is Milne–Kollár (`informal/pic-representability-campaign.md`); Kleiman §4 is the classical statement, not the path being built."
- **`hgraph/nodes/1de7c0c07e5b.md:10`** (docstring of `IsProjectiveWith.locallyOfFiniteType`, `Picard/ProjectiveMorphism.lean`) — "This lets the Quot-scheme endgame and the Hilbert-polynomial existence theorem derive finite type…". Fix: "the Quot-scheme lane" (retained substrate), not "endgame".
- **`hgraph/nodes/3b59ae27f454.md:18`** — mirror of `RiemannRoch_Adelic.tex:2057`; fixed by item 10.

## Already correct — do not re-edit

Blueprint: `content.tex` (input list only); `Picard_FGAPicRepresentability.tex:20-54` (two-routes framing, "The Lean development therefore pursues the Milne–Kollár route", Quot material explicitly retained as shared substrate), `:76-99` (both rational-point branches recorded, neither chosen), `:341-412` (`lem:smooth_proper_quotient` + `rem:smooth_proper_quotient_hypothesis`), `:414-560` (Milne–Kollár section; `thm:rigid_pushforward_gate` at `:533-552` correctly presented as established and `\leanok`, matching the real global instance `Adelic.instHasRigidPushforwardOfCurve`), `:654-666` (`rem:orbit_in_affine_hypothesis`), `:1085-1098`; `Picard_QuotScheme.tex:12-20` ("WHICH ROUTE THIS SERVES" note, already retained-substrate framing) and `:8435`; `Jacobian.tex:218-240` (`lem:curve_hypothesis_gap` — states the claim is false, names both closure options, "That choice is open"); `Picard_GrassmannianCells.tex`, `Picard_GrassmannianQuot.tex`, `Picard_GlueDescent.tex`, `Picard_SectionGradedRing.tex` (no project-state claims about the Picard endgame).

hgraph: `ecaf1d30fd8b` + its `comment-1.md`, `21d19f580320`, `1a5eca0ada83`, `c7fe2489be2e`, `9d07c794a903` (off-path status of the smooth-proper quotient, stated correctly); `03ccc83e89b1` + `comment-1.md` (sorry status and axiom leak measured); `e13e74f8a8db`, `9e46ba430c14` (rational point as unresolved decision, geometric integrality as theorem); `e9ca6d3bc2b6/comment-1.md` ("Retained, not revived"); `4d414128ae21`.

No mathematics needs deleting anywhere; every fix above is a relabelling of route/status prose.
