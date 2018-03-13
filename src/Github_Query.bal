package src;

public const string PROJECTS = string `query {
                                            organization(login:"wso2"){
                                                projects(first:100 states:OPEN){
                                                    nodes{
                                                        name
                                                        number
                                                    }
                                                }
                                            }
                                        }`;

public const string CARDS = string `query {
                                        organization(login:"wso2"){
                                            project(number:project_number){
                                                name
                                                columns(last:40){
                                                    nodes{
                                                        name
                                                        cards(last:100){
                                                            nodes{
                                                                id
                                                                state
                                                                note
                                                                createdAt
                                                                updatedAt
                                                                content{
                                                                    ... on Issue {
                                                                        title
                                                                        state
                                                                        url
                                                                    }

                                                                }
                                                                creator {
                                                                    login
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }`;