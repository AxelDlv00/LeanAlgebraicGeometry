NARROW, SYNCHRONOUS audit. Budget your work: aim for ~20 tool calls, then report. Two background reviewers already died mid-flight on this task, so prioritise finishing over exhaustiveness. READ-ONLY on source — report, do not edit.

Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge
Files: AlgebraicJacobian/Albanese/SymPowColimit.lean and AlgebraicJacobian/Albanese/AlbaneseFromColimit.lean (both new this session, both build green).

CLAIM UNDER TEST: the Albanese leg's last gap — "inhabit `SymPowData C n` for n >= 2", previously priced at 2400-3800 lines as a scheme quotient by a finite group action — has been LOSSLESSLY reduced to `HasColimitsOfShape (SingleObj (Equiv.Perm (Fin n))) Scheme`, and the AFFINE case is proved at every n.

Check these four, hardest first. Say plainly which are right; spend effort on what is wrong or overstated.

1. LOSSLESSNESS. `hasColimit_permDiagram_iff` claims `HasColimit (permDiagram C n)` iff existence of a pair `(D : SymPowData C n, hproj)`. Verify BOTH directions really prove that. Especially: in `SymPowData.isColimit`, does the `uniq` field genuinely establish colimit uniqueness, or does it prove something weaker/circular? And does `symPowOfColimit`'s `desc` field really give existence AND uniqueness of the factorisation?

2. NON-TRIVIALITY. Is there a way to satisfy `HasColimit (permDiagram C n)` that makes the whole reduction vacuous — e.g. the colimit being a terminal object, or the diagram being secretly constant/trivial so its colimit always exists and says nothing? Note `permEnd` maps `σ` to `permAut C σ⁻¹`; confirm that is a genuine monoid hom (not an anti-hom) and that `permDiagram` is the real S_n action rather than something degenerate. Also check `permAut_swap_ne_id` and `symPowDataTrivial_not_proj_perm` actually prove what their names say.

3. THE AFFINE CLAIM. `symPowData_affine` is stated for `(Under k)ᵒᵖ` with a `CartesianMonoidalCategory` instance installed via `ofHasFiniteProducts`. Two risks: (a) is `(Under k)ᵒᵖ` really the category of affine k-schemes; (b) does that installed monoidal instance agree with the products `permAut`/`Pi.π` actually use — if not, the theorem is about the wrong products. (I believe `permDiagram` only depends on `HasFiniteProducts` via `Pi.π`, never on the monoidal structure — verify or refute that.) Also: does `mem_sections_singleObj_iff` really justify the docstring's claim that the affine colimit is `Spec` of the S_n-invariants of the n-fold tensor power, or is that prose beyond what is proved?

4. DOCSTRING SCOPE. Read the module headers and the §5/§6 headers of SymPowColimit.lean critically. This lane has a documented history of correct theorems with over-generous scope sentences. In particular assess: "the affine case ... needs no construction here", "there is no over-category layer", and the final paragraph claiming the remaining work is assembling a `Scheme.GlueData`. Is anything asserted that the file does not prove?

Verify with `lake env lean` on scratch copies in /tmp and `#print axioms`. Do NOT trust `mcp__lean-lsp__lean_minimal_hypotheses` — I measured it returning "all 16 binders removable, empty breaks" on `exists_unique_albanese_of_scheme_colimits`, which is provably false (dropping the `φ` binder yields 4 unknown-identifier errors). If you use it, corroborate by hand.

Report: file:line, what is confirmed, what is overstated, what is wrong.
